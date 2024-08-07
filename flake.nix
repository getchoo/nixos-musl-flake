{
  description = "A small experiment in combining NixOS, musl, busybox, and other hipster trash";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      inherit (lib.systems.parse) abis tripleFromSystem;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = lib.genAttrs systems;
      nixpkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});

      # Get some extra information about all of our systems to use later
      parsedFor = forAllSystems (system: (lib.systems.elaborate system).parsed);

      # nixpkgs defaults to gnu/glibc when elaborating Linux doubles like
      # `x86_64-linux`. Make it use musl instead
      muslSystemFor = forAllSystems (system: parsedFor.${system} // { abi = abis.musl; });

      muslConfigurationFor = forAllSystems (
        system:
        lib.nixosSystem {
          modules = [
            ./configuration
            # Make sure our system configuration is built for musl
            { nixpkgs.hostPlatform.config = tripleFromSystem muslSystemFor.${system}; }
          ];
        }
      );
    in
    {
      checks = forAllSystems (
        system:
        let
          cpuArch = parsedFor.${system}.cpu.name;
        in
        {
          configuration = self.nixosConfigurations."musl-${cpuArch}".config.system.build.vm;
        }
      );

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixfmt-rfc-style);

      nixosConfigurations = {
        musl-x86_64 = muslConfigurationFor.x86_64-linux;
        musl-aarch64 = muslConfigurationFor.aarch64-linux;
      };
    };
}
