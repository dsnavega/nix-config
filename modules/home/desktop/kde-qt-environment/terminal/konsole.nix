{ config, pkgs, lib, ... }:
let
  colors = config.lib.stylix.colors;

  schemeName = "Stylix";

  # Konsole stores colors as "r,g,b" decimal triples, the same format
  # kdeglobals uses. Stylix exposes those components directly on the base16
  # slots, so no hex parsing is needed here.
  rgb = name: "${colors."${name}-rgb-r"},${colors."${name}-rgb-g"},${colors."${name}-rgb-b"}";

  entry = section: name: ''
    [${section}]
    Color=${rgb name}
  '';

  # base16's standard terminal mapping. Stylix's named aliases resolve to
  # exactly these slots (red == base08, green == base0B, ...) and it draws no
  # distinction between normal and bright, so the Intense variants reuse the
  # same colors - except the two that genuinely differ: bright black is the
  # base03 comment grey, bright white the base07 extreme.
  colorscheme =
    entry "Background" "base00"
    + entry "BackgroundIntense" "base00"
    + entry "BackgroundFaint" "base00"
    + entry "Foreground" "base05"
    + entry "ForegroundIntense" "base07"
    + entry "ForegroundFaint" "base04"

    + entry "Color0" "base00" # black
    + entry "Color1" "base08" # red
    + entry "Color2" "base0B" # green
    + entry "Color3" "base0A" # yellow
    + entry "Color4" "base0D" # blue
    + entry "Color5" "base0E" # magenta
    + entry "Color6" "base0C" # cyan
    + entry "Color7" "base05" # white

    + entry "Color0Intense" "base03"
    + entry "Color1Intense" "base08"
    + entry "Color2Intense" "base0B"
    + entry "Color3Intense" "base0A"
    + entry "Color4Intense" "base0D"
    + entry "Color5Intense" "base0E"
    + entry "Color6Intense" "base0C"
    + entry "Color7Intense" "base07"

    + ''
      [General]
      Description=${schemeName}
      Opacity=1
    '';

  profile = ''
    [Appearance]
    ColorScheme=${schemeName}
    Font=${config.stylix.fonts.monospace.name},${toString config.stylix.fonts.sizes.terminal},-1,5,50,0,0,0,0,0

    [Scrolling]
    HistoryMode=2
    ScrollBarPosition=2

    [General]
    Name=${schemeName}
    Parent=FALLBACK/
  '';
in
{
  # Konsole discovers profiles and schemes by scanning this directory, so the
  # names of these files are what tie them together (Appearance/ColorScheme
  # above refers to Stylix.colorscheme). This also themes Kate's embedded
  # terminal panel, which is a Konsole KPart using the default profile.
  home.file = {
    ".local/share/konsole/${schemeName}.colorscheme".text = colorscheme;
    ".local/share/konsole/${schemeName}.profile".text = profile;
  };

  # konsolerc is left writable rather than symlinked into the store, so
  # Konsole can still persist window geometry and similar runtime state -
  # only the default profile is managed. Same approach as
  # modules/home/text-editor/kate.nix.
  home.activation.konsoleDefaultProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} \
      --file "$HOME/.config/konsolerc" \
      --group "Desktop Entry" \
      --key "DefaultProfile" \
      "${schemeName}.profile"
  '';
}
