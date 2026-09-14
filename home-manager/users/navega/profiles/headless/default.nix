# Headless: terminal environment only. Servers, VMs, remote boxes.
{ self, ... }:
{
  imports = [
    "${self}/modules/home/shell-environment"
  ];
}
