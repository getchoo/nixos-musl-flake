{ pkgs, ... }:
{
  environment = {
    # NOTE: This is what prints the fun error message about
    # binaries not compiled for NixOS not working with it
    #
    # It's here because on x86_64 systems, a 32-bit `ld` stub
    # is built against `pkgs.pkgsi686Linux`; nixpkgs doesn't
    # support a pure i686 musl bootstrap, so it throws an eval
    # error. womp womp
    stub-ld.enable = false;
  };

  # HACK: nixpkgs instantiated for musl doesn't have glibc locales, so the
  # default value throws eval errors
  # This will probably break something
  i18n.glibcLocales = pkgs.emptyFile;
}
