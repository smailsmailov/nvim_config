sudo apt install -y python3-pip nodejs npm golang composer

# JavaScript/TypeScript/HTML/CSS/JSON/Markdown

npm install -g eslint prettier typescript stylelint jsonlint markdownlint-cli

# Python

pip install --user flake8 black pylint mypy isort

# PHP

composer global require friendsofphp/php-cs-fixer phpstan/phpstan vimeo/psalm

# Go

go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/tools/cmd/goimports@latest

# Dockerfile

curl -L https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o ~/.local/bin/hadolint && chmod +x ~/.local/bin/hadolint

# ИЛИ для macOS:

brew install hadolint

# Makefile

go install github.com/mrtazz/checkmake@latest

~/.eslintrc.json
{
"rules": {
"no-console": "off"
}
}

~/.config/flake8
[flake8]
max-line-length = 120
ignore = E203,W503

UPDATE

# JavaScript

npm update -g eslint prettier

# Python

pip install --upgrade flake8 black

# PHP

composer global update

# Go

go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
