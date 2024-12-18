{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true; # firmware update utility

  zramSwap = {
    enable = true;
    memoryPercent = 50; # ZRAM swap with half total physical RAM size
  };

  networking.hostName = "rotterdam";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = null;
  services.automatic-timezoned.enable = true;
  services.geoclue2.enableDemoAgent = lib.mkForce true; # because Gnome...
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

  services.fprintd.enable = true; # enable fingerprint

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.mutableUsers = false; # ensure users and groups are set declaratively
  users.users.raf = {
    isNormalUser = true;
    description = "Raf";
    hashedPassword = "$y$j9T$AgJhH28Mik/VmKWy979af0$3Z9vLnJR.D/fp/g2ym.ZbxaAqDZay4fORkkBcGGlTi9";
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.vim.defaultEditor = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark; # not CLI version
  };

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
      jetbrains.idea-ultimate # intelliJ :(
      mattermost-desktop
      slack
      spotify

      git
      gnupg
      httpie
      pinentry-gnome3 # for gpg, TODO: remove
      lf
      libqalculate
      timewarrior
      pkgs-unstable.typst
      pkgs-unstable.tinymist # typst lsp
      pkgs-unstable.typstyle
      zathura

      binutils # e.g., strings
      file
      unzip
    ];

    programs.java.enable = true;

    programs.zsh = {
      enable = true;
      shellAliases = {
        cat = "bat";
        fd = "fd -u"; # unrestricted search (include hidden and ignored files)
        mv = "mv -i"; # prompt before overwrite
        cp = "cp -i"; # prompt before overwrite
        rm = "rm -I"; # prompt before removing >3 files or recursively
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
      settings = {
        custom.timew = {
          description = "Timewarrior time-tracking status";
          when = ''[ "$(timew get dom.active)" = "1" ]'';
          command = "timew | head -n1 | cut -d' ' -f2-";
          style = "bold 111";
          symbol = "⏳";
          format = "tracking [$symbol ($output )]($style)";
        };
      };
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

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        streetsidesoftware.code-spell-checker
        tomoki1207.pdf # pdf preview
        mkhl.direnv

        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        myriad-dreamin.tinymist # typst
        hashicorp.terraform
        hashicorp.hcl
        redhat.java
        vue.volar
        esbenp.prettier-vscode
      ];
      userSettings =
        {
          "files.autoSave" = "onFocusChange";
          "files.insertFinalNewline" = true;
          "files.trimFinalNewlines" = true;
          "editor.formatOnSave" = true;
          "editor.rulers" = [ 80 ];
          "nix.formatterPath" = "nixfmt";
          "tinymist.exportPdf" = "onDocumentHasTitle";
          "tinymist.formatterMode" = "typstyle";
        }
        // (
          let
            prettierLangs = [
              "javascript"
              "typescript"
              "json"
              "jsonc"
              "html"
              "css"
              "scss"
              "markdown"
              "yaml"
              "vue"
              "graphql"
              "typescriptreact"
              "javascriptreact"
            ];
            withBrackets = map (lang: "[${lang}]") prettierLangs;
            scope = builtins.concatStringsSep "" withBrackets;
          in
          {
            ${scope}."editor.defaultFormatter" = "esbenp.prettier-vscode";
          }
        );
      keybindings = [
        {
          key = "alt+t";
          command = "editor.action.goToTypeDefinition";
        }
        {
          key = "shift+alt+up";
          command = "editor.action.copyLinesUpAction";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "shift+alt+down";
          command = "editor.action.copyLinesDownAction";
          when = "editorTextFocus && !editorReadonly";
        }
      ];
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
    nixfmt-rfc-style
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # lock flake registry to keep sync'd with inputs
    # (e.g., used by `nix run pkgs#name`)
    registry = {
      pkgs.flake = inputs.nixpkgs; # alias to nixpkgs
      unstable.flake = inputs.nixpkgs-unstable;
    };

    nixPath = [
      "nixpkgs=flake:pkgs"
      "unstable=flake:unstable"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  system.stateVersion = "24.05";
}
