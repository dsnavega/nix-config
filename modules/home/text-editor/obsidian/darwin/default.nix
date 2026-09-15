{ lib, ... }:
let
  # vault targets are relative to $HOME
  vaultsDir = "Documents/Obsidian";
  vaults = map (name: "${vaultsDir}/${name}") [
    "Notes"
    "Panacea Cooperative Research"
  ];
in
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;
    # .app installed via cask
    package = null;
    # registers each vault in obsidian.json
    vaults = lib.genAttrs vaults (_: { });
  };
  stylix.targets.obsidian = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
    polarity.enable = true;
    # stylix keys vaults by name, which doubles as the target path
    vaultNames = vaults;
  };
}
