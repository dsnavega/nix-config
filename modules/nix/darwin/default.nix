{ ... }:
{
  imports = [
    ../common
    ../packages
  ];

  nix.gc.interval = {
    Weekday = 0;
    Hour = 3;
    Minute = 0;
  };

}
