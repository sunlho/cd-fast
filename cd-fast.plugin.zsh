# ~/.oh-my-zsh/custom/plugins/cd-fast/cd-fast.plugin.zsh

# ==============================================
# CD-FAST: Quick directory navigation for Zsh
#
# Usage:
#   1. Add to .zshrc:
#     CD_FAST="p:~/projects;d:~/Downloads;tmp:/tmp"
#   2. Run `cdp`, `cdd`, `cdtmp` + Tab completion
# Other:
#   setting CD_FAST_OVERWRITE to 1 will overwrite existing commands
# ==============================================

: "${CD_FAST:=""}"
: "${CD_FAST_OVERWRITE:=0}"

typeset -gA _cd_fast_commands=()

_cd_fast_setup() {
    local entries=("${(s:;:)CD_FAST}")
    local entry alias_name target_dir

    for entry in "${entries[@]}"; do
        entry="${entry//[[:space:]]/}"
        if [[ -z "$entry" ]]; then
            continue
        fi

        if [[ "$entry" != *:* ]]; then
            echo "[cd-fast] Invalid entry: '$entry' (format should be 'alias:path')" >&2
            continue
        fi

        alias_name="${entry%%:*}"
        target_dir="${entry#*:}"
        target_dir="${target_dir/#\~/$HOME}"

        if [[ -z "$alias_name" ]]; then
            echo "[cd-fast] Error: Alias or path is empty in '$entry'" >&2
            continue
        fi

        local command_name="cd${alias_name}"

        [[ -n "${_cd_fast_commands[$command_name]}" ]] && continue

        if (( ! CD_FAST_OVERWRITE )); then
            if (( $+commands[$command_name] )) || typeset -f "$command_name" &>/dev/null; then
              echo "[cd-fast] Warning: '$command_name' exists (set CD_FAST_OVERWRITE=1 to override)" >&2
              continue
            fi
        fi

        if [ ! -d "$target_dir" ]; then
            echo "[cd-fast] Error: Directory '$target_dir' (for 'cd${alias_name}') does not exist!" >&2
            continue
        fi

        eval "
          function ${command_name}() {
            # 如果没有传入任何参数，直接进入目标目录
            if [[ \$# -eq 0 ]]; then
              cd \"${target_dir}\"
            else
              # 否则，根据参数进入目标目录的相对路径
              cd \"${target_dir}\" && cd \"\$@\"
            fi
          }
        "

        compctl -W "${target_dir}" -/ "${command_name}"

        _cd_fast_commands[$command_name]=1
    done
}

_cd_fast_setup
