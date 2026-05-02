if status is-interactive
# Commands to run in interactive sessions can go here
end

set -U fish_greeting

fish_vi_key_bindings

alias v='nvim'

set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

# Set Path Variable
set PATH ~/Desktop/platform-tools $PATH
