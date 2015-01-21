
#
# Aliases
#

alias ls="ls -lG"
alias v="mvim"

recursive-find() {
    setopt local_options
    setopt extended_glob

    ls -1dG (#l)**/${~@}(D)
}

alias lsf="noglob recursive-find"

