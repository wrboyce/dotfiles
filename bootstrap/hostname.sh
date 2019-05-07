#!/usr/bin/env bash
set -eu

if [ "${DOTFILES_BOOTSTRAP-false}" = true ]; then
    case "${OSTYPE}" in
        darwin*)
            # setup hostname (if provided)
            if [ -n "${BOOTSTRAP_HOSTNAME-}" ]; then
                dotfile_info "Setting hostname to '${BOOTSTRAP_HOSTNAME-}'"
                sudo scutil --set HostName "${BOOTSTRAP_HOSTNAME-}"
                sudo scutil --set ComputerName "$(hostname -s)"
                sudo scutil --set LocalHostName "$(hostname -s)"
            fi
            ;;
    esac
fi
