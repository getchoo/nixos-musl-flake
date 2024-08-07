{
  imports = [
    ./busybox.nix
    ./minimal.nix # Making this configuration a bit smaller to save on build time & download size
    ./module-fixes.nix # Module-level fixes for musl
  ];

  boot.loader.systemd-boot.enable = true;

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "ramfs";
    };
  };

  # You probably know the drill. Don't change this.
  system.stateVersion = "24.11";
}
