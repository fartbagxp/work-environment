# Overview

This is an overview of how to setup VS code.

## Extensions

This is how we would backup and restore VS code extensions.

Run `code --list-extensions | xargs -L 1 echo code --install-extension`

A list of what extensions to install will appear.

```sh
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension mauve.terraform
code --install-extension ms-python.python
code --install-extension yzane.markdown-pdf
```

## User Settings

The user settings can be access via `Ctrl + P`, search for `> Preferences: Open Settings`.

Settings can be found [here](user-settings.json).