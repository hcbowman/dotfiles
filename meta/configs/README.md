# Configs

This folder contains the `Dotbot` commands, `Link, Create, Shell, etc.` that are specific to each dotfile program.

## Usage

Create a `.yaml` file named after the desired program, like `vim` or `zsh`.  Then add `Dotbot` commands to the file. Here is a list of the [commands](https://github.com/anishathalye/dotbot#directives).

## Example

`$HOME/.dotfiles/meta/configs/zsh.yaml`
```
- link:
  $HOME/.zshrc: apps/zsh/zshrc
```

### Notes

**Keep the `.yaml` files in `$HOME/.dotfiles/meta/configs`.*

**Each file corresponds to a separate folder at `$HOME/.dotfiles/apps`. program we want to manage dotfiles.*

**must be .yaml, not .yml?*