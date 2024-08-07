{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.busybox ];
}
