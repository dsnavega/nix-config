{ pkgs, ... }:
{
  programs.iotop.enable = true;
  programs.mtr.enable = true;
  services.smartd.enable = true;
  services.sysstat.enable = true;
  environment.systemPackages = with pkgs; [
    smartmontools
  ];

}
