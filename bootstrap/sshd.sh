#!/usr/bin/env bash
set -eu

if [ "${DOTFILES_BOOTSTRAP-false}" = true ]; then
    case "${OSTYPE}" in
        darwin*)
            # enable ssh
            if [ "$(sudo systemsetup -getremotelogin)" != "Remote Login: On" ]; then
                dotfile_info "Enabling SSH"
                sudo systemsetup -setremotelogin On
            fi
            ;;
    esac
fi
