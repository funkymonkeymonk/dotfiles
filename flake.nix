{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.emacs
	      pkgs.google-chrome
	      pkgs.trippy
	      pkgs.logseq
	      pkgs.ripgrep
	      pkgs.fd
	      pkgs.coreutils
	      pkgs.clang
	      pkgs.git
          pkgs.slack
          pkgs.karabiner-elements
          pkgs.alacritty
          pkgs.gh
        ];

      nix.enable = false;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
   
      # Homebrew configuration
      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
	
	#caskArgs.no_quarantine = true;
        casks = [
	  "raycast"
	  "1password"
	  "1password-cli"
	  "syncthing"
	  "zed"
	  # "amethyst"
	];
      };

    # TODO generate ssh-key if it does not already exist
    # TODO register the ssh key in git locally
    # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
    # https://discourse.nixos.org/t/how-to-set-up-a-system-wide-ssh-agent-that-would-work-on-all-terminals/14156/5
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Will-Stride-MBP
    darwinConfigurations."Will-Stride-MBP" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        {
          system.primaryUser = "willweaver";
	}
      ];
    };
  };
}
