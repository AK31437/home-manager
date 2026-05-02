# home-manager
home.nix + .dotfiles

### Installing home-manager
#### Standalone installation
1. Make sure you have a working Nix installation. Specifically, make sure that your user is able to build and install Nix packages. For example, you should be able to successfully run a command like nix-instantiate '<nixpkgs>' -A hello without having to switch to the root user. For a multi-user install of Nix this means that your user must be covered by the allowed-users Nix option. On NixOS you can control this option using the nix.settings.allowed-users system option.
2. Add the appropriate Home Manager channel. If you are following Nixpkgs master or an unstable channel you can run
    
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update

    and if you follow a Nixpkgs version 25.11 channel you can run

    nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
    nix-channel --update

3. Run the Home Manager installation command and create the first Home Manager generation:

    nix-shell '<home-manager>' -A install

4. Once finished, Home Manager should be active and available in your user environment.

5. If you do not plan on having Home Manager manage your shell configuration then you must source the

    $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

file in your shell configuration. Alternatively source

    /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh

when managing home configuration together with system configuration.

This file can be sourced directly by POSIX.2-like shells such as Bash or Z shell. Fish users can use utilities such as foreign-env or babelfish.

For example, if you use Bash then add

    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

to your ~/.profile file.

If instead of using channels you want to run Home Manager from a Git checkout of the repository then you can use the home-manager.path option to specify the absolute path to the repository.

6. Once installed you can see Using Home Manager for a more detailed description of Home Manager and how to use it.




