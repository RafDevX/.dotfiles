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

  time.timeZone = "Europe/Stockholm"; # TODO: enable auto tz switch
  i18n.defaultLocale = "en_US.UTF-8";

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
    packages = with pkgs; [
      discord
      brave
      timewarrior
      git
      gnupg
      pinentry-gnome3 # for gpg, TODO: remove
      vscode
      spotify
      slack
      flameshot
      lf
      zathura
      mattermost-desktop
      httpie
    #  thunderbird
    ];
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
  };

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
