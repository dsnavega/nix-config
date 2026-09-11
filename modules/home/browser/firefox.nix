_:

{

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
        };
        extensions = {
          force = true;
        };
      };
    };
  };

  stylix.targets.firefox = {
    enable = true;
    colorTheme.enable = true;
    profileNames = [ "default" ];
  };

}
