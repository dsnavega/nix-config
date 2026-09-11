# Headless: terminal environment only. Servers, VMs, remote boxes.
{ self, ... }:
{
  imports = [
    ../../settings
    "${self}/modules/home/shell-environment"
  ];
}
