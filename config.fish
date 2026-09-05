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

    # Aliases ----------------------------------------------------
    
    alias v='nvim'

    alias cpuago='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' # check available active scaling_governor
    alias cpugov='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' # active scaling_governor
    alias cpuper='echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor' # set scaling_governor to performance mode
    alias cpupow='echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor' # set scaling_governor to powersave mode
    alias cpufre='watch cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq' # watch cpu frequency live

    # ------------------------------------------------------------
    
end