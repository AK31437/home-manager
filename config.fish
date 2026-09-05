# Into the `status is-interactive` block goes everything that only matters in a
# real terminal session: prompts, key bindings, aliases, greeting.
# Outside it goes everything that must also apply to non-interactive fish
# (scripts, `fish -c`, ...): telemetry opt-outs, PATH, locale, editor.

# dotnet telemetry: apply to non-interactive sessions too
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

if status is-interactive
    # Commands to run in interactive sessions can go here

    # suppress the greeting - global (session-scoped), not universal
    set -g fish_greeting

    fish_vi_key_bindings

    alias v='nvim'
end