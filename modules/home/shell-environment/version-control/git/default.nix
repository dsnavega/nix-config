{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "David Navega";
      user.email = "dsnavega@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
    lfs.package = pkgs.git-lfs;
  };

  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    package = pkgs.lazygit;
  };

  programs.gh = {
    enable = true;
  };

}
