# ZSH CD Fast

## Introduction

**ZSH CD Fast** is a Zsh plugin for quickly switching between directories. You can assign aliases to
frequently used directories and access them using concise commands.

## Installation

1. Clone or copy the plugin into your Zsh plugin directory, for example:

   ```zsh
   ~/.oh-my-zsh/custom/plugins/cd-fast/
   ```

2. Edit your `~/.zshrc` file and add the plugin name:

   ```zsh
   plugins=(
     ...
     cd-fast
   )
   ```

3. Configure the `CD_FAST` environment variable to define directory aliases. For example:

   ```zsh
   export CD_FAST="p:~/projects;d:~/Downloads"
   ```

   > ⚠️ **Note:** This line should be placed _before_ `source $ZSH/oh-my-zsh.sh`.

4. Reload your Zsh configuration:

   ```zsh
   source ~/.zshrc
   ```

## Usage

Based on the aliases you define in `CD_FAST`, the plugin will automatically create corresponding `cd`
commands. For example:

- `cdp` → switches to `~/projects`
- `cdd` → switches to `~/Downloads`

## Example

```zsh
export CD_FAST="p:~/projects;d:~/Downloads;w:~/workspace"

# Now you can use:
cdp   # → ~/projects
cdd   # → ~/Downloads
cdw   # → ~/workspace
```
