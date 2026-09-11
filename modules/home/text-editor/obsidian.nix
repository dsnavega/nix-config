_:
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;
  };
  stylix.targets.obsidian = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
    polarity.enable = true;
    vaultNames = [
      "Obsidian Vault"
    ];
  };
}
