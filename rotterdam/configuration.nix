{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "rotterdam";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = null;
  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://beacondb.net/v1/geolocate";
  # ^ necessary because Mozilla Location Service has been shut down

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "compose:rctrl";
  };

  services.printing.enable = true; # enable CUPS

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.raf = {
    isNormalUser = true;
    description = "Raf";
    hashedPassword = "$y$j9T$7kZrA1k9TExX62k37mrpa0$Woud8M1XOgszIaN8UDpTEJq0hrgmuXY60FfkVTVngV7"; # TODO: change
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.vim.defaultEditor = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.raf = {
    home.stateVersion = "24.05";
    home.username = "raf";
    home.homeDirectory = "/home/raf";

    home.packages = with pkgs; [
      brave
      discord
      flameshot
      mattermost-desktop
      slack
      spotify
      vscode

      git
      gnupg
      httpie
      pinentry-gnome3 # for gpg, TODO: remove
      lf
      libqalculate
      timewarrior
      typst
      typst-lsp
      typstyle
      zathura
    ];

    programs.zsh = {
      enable = true;
      shellAliases = {
        cat = "bat";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "colored-man-pages"
          "command-not-found"
          "docker-compose"
          "extract"
          "git"
          "safe-paste"
        ];
      };
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            hash = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.35.0";
            hash = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
          };
        }
      ];
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    home.sessionVariables._ZO_ECHO = "1"; # echo matched dir before navigating

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
    };

    programs.bat.enable = true;
    programs.htop.enable = true;

    programs.git = {
      enable = true;
      userName = "Rafael Oliveira";
      userEmail = "rafdev.x@gmail.com";
      signing = {
        key = "2997CA7C4C3135D1";
        signByDefault = true;
      };
      extraConfig = {
        core.whitespace = "tab-in-indent,tabwidth=4";
        init.defaultBranch = "master";
        commit.verbose = true;
        pull.rebase = true;
        rerere.enabled = true;
        url."git@github.com:".pushinsteadOf = "https://github.com/";
      };
      includes = [
          {
            condition = "gitdir:~/Documents/KTH/";
            contents.user = {
              email = "rmfseo@kth.se";
            };
          }
      ];
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "*.datasektionen.se" = {
          user = "rmfseo";
        };
      };
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    nerdfonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk-sans
  ];

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fd
    ripgrep
  ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = "24.05";
}
