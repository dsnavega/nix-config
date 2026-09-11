{ config, lib, ... }:
let
  colors = config.lib.stylix.colors;

  # Stylix's own KDE target only ships the palette as a Plasma
  # "look and feel" package and expects plasma-apply-lookandfeel to copy it
  # into kdeglobals on login. i3 never runs that, so the [Colors:*] groups
  # never land and KColorScheme falls back to its built-in light Breeze
  # defaults - which is why KDE apps ignored the dark scheme. Writing the
  # groups straight into kdeglobals removes Plasma from the loop entirely.
  stylixKde = builtins.head config.xdg.systemDirs.config;

  # KDE stores each color as a comma-separated "r,g,b" decimal triple.
  rgb = name: "${colors."${name}-rgb-r"},${colors."${name}-rgb-g"},${colors."${name}-rgb-b"}";

  # Role mapping follows Stylix's "General colors" style guide, which is what
  # KDE apps fall under (the guide puts file managers and other bundled
  # desktop applications in the general category rather than a special one):
  # https://nix-community.github.io/stylix/styling.html
  #
  #   Default background: base00     Default text: base05
  #   Alternate background: base01   Alternate text: base04
  #   Selection background: base02
  #   Warning: base0A   Urgent: base09   Error: base08
  common = {
    BackgroundNormal = rgb "base00";
    BackgroundAlternate = rgb "base01";
    ForegroundNormal = rgb "base05";
    ForegroundActive = rgb "base05";
    # "Alternate text" - KDE uses this role for section headings and
    # descriptive labels, not only for greyed-out ones. base03 would be the
    # tempting pick but it is tuned to sit close to the background (~51 luma
    # from base00 on a dark scheme, unreadable); base04 gives ~143 while
    # still reading as muted next to base05.
    ForegroundInactive = rgb "base04";
    ForegroundNegative = rgb "base08"; # Error
    ForegroundNeutral = rgb "base0A"; # Warning
    # The guide has no "positive" role; base0B is its green.
    ForegroundPositive = rgb "base0B";
    ForegroundLink = rgb "base0D";
    ForegroundVisited = rgb "base0E";
    # Focus and hover indicators, matching "Focused window border: base0D"
    # from the window manager section - the same accent i3 uses.
    DecorationFocus = rgb "base0D";
    DecorationHover = rgb "base0D";
  };

  # "Lists and selections": a selected row only changes its background, to
  # base02. Text stays base05, so nothing needs a contrasting foreground.
  # This deliberately replaces the earlier base0D-background/base00-text
  # inversion: that is the guide's "dark text color widgets" pattern, which
  # is reserved for widgets drawn on vibrant accent backgrounds, not for
  # ordinary list selections.
  selection = common // {
    BackgroundNormal = rgb "base02";
    BackgroundAlternate = rgb "base02";
  };

  # How disabled/inactive widgets are dimmed. Stylix ships 0.5, which fades
  # them halfway to the background; stacked on top of ForegroundInactive that
  # made whole paragraphs of Konsole's settings dialog unreadable. 0.3 still
  # reads as "disabled" without disappearing into the background.
  effect = {
    ColorEffect = "0";
    ColorAmount = "0";
    ContrastEffect = "1";
    ContrastAmount = "0.3";
    IntensityEffect = "0";
    IntensityAmount = "0";
  };

  colorGroups = {
    "Colors:Window" = common;
    "Colors:View" = common;
    "Colors:Button" = common;
    # Tooltips are "Notifications and popups": background base00, text base05,
    # border base0D - which is what common already provides.
    "Colors:Tooltip" = common;
    "Colors:Complementary" = common;
    "Colors:Selection" = selection;
    "ColorEffects:Disabled" = effect;
    "ColorEffects:Inactive" = effect;
  };
in
{
  # Stylix's generated kdeglobals (fonts, scheme name) plus the [Colors:*]
  # groups it leaves for Plasma to apply. The two sets of groups don't
  # overlap, so appending is a clean merge.
  home.file.".config/kdeglobals".text =
    builtins.readFile "${stylixKde}/kdeglobals" + "\n" + lib.generators.toINI { } colorGroups;

  home.file.".config/kded5rc".source = "${stylixKde}/kded5rc";
  home.file.".config/kcminputrc".source = "${stylixKde}/kcminputrc";
}
