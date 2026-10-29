--[[
  ai_ask — выделил текст, задал вопрос, получил Claude Code / OpenCode
  в плавающем окне по центру с уже вставленным промптом.

  У каждого инструмента своя сессия (терминал живёт в фоне, пока не выйдешь из CLI).

  Биндинги:
    <leader>ac (visual) — спросить Claude Code
    <leader>ao (visual) — спросить OpenCode
    <leader>aa (normal) — показать/спрятать последнее окно
    q          (внутри окна) — спрятать окно, i — писать в CLI
    <C-q>      (при вводе в CLI) — спрятать окно
]]

local M = {}

local tools = {
	claude = {
		name = "Claude Code",
		cmd = function(prompt)
			return { "claude", prompt }
		end,
	},
	opencode = {
		name = "OpenCode",
		cmd = function(prompt)
			return { "opencode", "--prompt", prompt }
		end,
	},
}

-- state[tool] = { buf, chan }
local state = {}
local last_tool = nil
local win = nil

-- Забираем выделение до выхода из visual mode
local function get_selection()
	local mode = vim.fn.mode()
	local s, e = vim.fn.getpos("v"), vim.fn.getpos(".")
	local lines = vim.fn.getregion(s, e, { type = mode })
	local l1, l2 = math.min(s[2], e[2]), math.max(s[2], e[2])
	return table.concat(lines, "\n"), l1, l2
end

local function build_prompt(question, text, l1, l2)
	local file = vim.fn.expand("%:.")
	local ft = vim.bo.filetype
	local where = file ~= "" and string.format("%s:%d-%d", file, l1, l2) or "[без файла]"
	return string.format("%s\n\nФрагмент из %s:\n```%s\n%s\n```", question, where, ft, text)
end

local function alive(tool_key)
	local s = state[tool_key]
	return s and vim.api.nvim_buf_is_valid(s.buf)
end

local function win_config(tool_key)
	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.8)
	return {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2) - 1,
		style = "minimal",
		border = "rounded",
		title = " " .. tools[tool_key].name .. " ",
		title_pos = "center",
	}
end

function M.hide()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_hide(win)
	end
	win = nil
end

local function show(tool_key)
	M.hide()
	local buf = state[tool_key].buf
	win = vim.api.nvim_open_win(buf, true, win_config(tool_key))
	last_tool = tool_key
	-- открываемся в normal mode, как neo-tree: q прячет, i — писать в CLI.
	-- курсор на последней строке, чтобы окно следило за выводом
	vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
end

local function create_session(tool_key, prompt)
	local buf = vim.api.nvim_create_buf(false, true)
	state[tool_key] = { buf = buf }
	show(tool_key)

	state[tool_key].chan = vim.fn.jobstart(tools[tool_key].cmd(prompt), {
		term = true,
		cwd = vim.fn.getcwd(),
		on_exit = function()
			-- вышли из CLI — убираем окно и сессию
			vim.schedule(function()
				if state[tool_key] and state[tool_key].buf == buf then
					state[tool_key] = nil
				end
				if vim.api.nvim_buf_is_valid(buf) then
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end
			end)
		end,
	})
	vim.bo[buf].bufhidden = "hide"

	local opts = { buffer = buf, desc = "Спрятать AI окно" }
	vim.keymap.set({ "t", "n" }, "<C-q>", M.hide, opts)
	vim.keymap.set("n", "q", M.hide, opts)
	-- как в neo-tree float: ушёл из окна — оно прячется
	vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, callback = M.hide })
end

-- Сессия уже есть — вставляем промпт в неё (bracketed paste) и отправляем
local function send_to_session(tool_key, prompt)
	show(tool_key)
	local chan = state[tool_key].chan
	vim.fn.chansend(chan, "\27[200~" .. prompt .. "\27[201~")
	vim.defer_fn(function()
		pcall(vim.fn.chansend, chan, "\r")
	end, 100)
end

function M.ask(tool_key)
	local tool = tools[tool_key]
	local text, l1, l2 = get_selection()
	-- выходим из visual mode
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)

	vim.ui.input({ prompt = tool.name .. " ❯ " }, function(question)
		if question == nil then
			return -- отмена (Esc)
		end
		if question == "" then
			question = "Объясни этот код."
		end
		local prompt = build_prompt(question, text, l1, l2)
		if alive(tool_key) then
			send_to_session(tool_key, prompt)
		else
			create_session(tool_key, prompt)
		end
	end)
end

function M.toggle()
	if win and vim.api.nvim_win_is_valid(win) then
		return M.hide()
	end
	if not (last_tool and alive(last_tool)) then
		-- последняя сессия закрыта — берём любую живую
		last_tool = nil
		for key in pairs(tools) do
			if alive(key) then
				last_tool = key
				break
			end
		end
	end
	if not last_tool then
		return vim.notify("Нет открытых AI сессий", vim.log.levels.INFO)
	end
	show(last_tool)
end

function M.setup()
	vim.keymap.set("x", "<leader>ac", function()
		M.ask("claude")
	end, { desc = "Ask Claude Code" })
	vim.keymap.set("x", "<leader>ao", function()
		M.ask("opencode")
	end, { desc = "Ask OpenCode" })
	vim.keymap.set("n", "<leader>aa", M.toggle, { desc = "Toggle AI window" })

	vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			if win and vim.api.nvim_win_is_valid(win) and last_tool then
				vim.api.nvim_win_set_config(win, win_config(last_tool))
			end
		end,
	})
end

return M
