# ZSH CD Fast

## 简介

**ZSH CD Fast** 是一个用于快速切换目录的 Zsh 插件。你可以为常用目录设置别名，并通过简洁的命令快速访问这些目录
。

## 安装步骤

1. 将插件克隆或复制到你的 Zsh 插件目录，例如：

   ```zsh
   ~/.oh-my-zsh/custom/plugins/cd-fast/
   ```

2. 修改你的 `~/.zshrc` 文件，添加插件名称：

   ```zsh
   plugins=(
     ...
     cd-fast
   )
   ```

3. 配置 `CD_FAST` 环境变量，定义目录别名。例如：

   ```zsh
   export CD_FAST="p:~/projects;d:~/Downloads"
   ```

   > ⚠️ **注意：** 请确保此行代码放在 `source $ZSH/oh-my-zsh.sh` 之前。

4. 重新加载 Zsh 配置文件：

   ```zsh
   source ~/.zshrc
   ```

## 使用方法

根据你在 `CD_FAST` 中定义的别名，插件会自动创建对应的 `cd` 命令。例如：

- `cdp` → 切换到 `~/projects`
- `cdd` → 切换到 `~/Downloads`

## 示例

```zsh
export CD_FAST="p:~/projects;d:~/Downloads;w:~/workspace"

# 现在可以使用：
cdp   # → ~/projects
cdd   # → ~/Downloads
cdw   # → ~/workspace
```
