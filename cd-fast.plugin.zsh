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

autoload -Uz compinit && compinit

: "${CD_FAST:=""}"
: "${CD_FAST_OVERWRITE:=0}"

typeset -gA _cd_fast_commands=()

_cd_fast_setup() {
    local entries=("${(s:;:)CD_FAST}")
    local entry alias_name target_dir

    for entry in "${entries[@]}"; do
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

        if (( ! CD_FAST_OVERWRITE )) && \
            (( $+commands[$command_name] )) || typeset -f "$command_name" >/dev/null; then
            echo "[cd-fast] Warning: '$command_name' exists (set CD_FAST_OVERWRITE=1 to override)" >&2
            continue
        fi

        if [ ! -d "$target_dir" ]; then
            echo "[cd-fast] Error: Directory '$target_dir' (for 'cd${alias_name}') does not exist!" >&2
            continue
        fi

        eval "function cd${alias_name}() {
            if [ ! -d \"${target_dir}\" ]; then
                echo \"Error: '${target_dir}' does not exist!\" >&2
                return 1
            fi
            if [ \$# -eq 0 ]; then
                cd \"${target_dir}\"
            else
                cd \"${target_dir}/\${1}\"
            fi
        }"

        eval "function _cd${alias_name}_completion() {
            local -a subdirs
            subdirs=(\$(find \"${target_dir}\" -maxdepth 1 -type d -exec basename {} \; 2>/dev/null))
            _describe 'cd${alias_name} targets' subdirs
        }"

        compdef "_cd${alias_name}_completion" "cd${alias_name}"

        _cd_fast_commands[$command_name]=1
    done
}

_cd_fast_setup
