{ modulesPath, ... }:
{
  imports = [
    # The configuration is mainly for testing. We don't need to actually use much
    (modulesPath + "/profiles/minimal.nix")
    # This includes perl
    (modulesPath + "/profiles/perlless.nix")
  ];
}
