{ config, pkgs, lib, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
  themeName = "Stylix";
  textStyle =
    color:
    extra: { text-color = color; selected-text-color = color; } // extra;
  theme = {
    metadata = {
      name = themeName;
      revision = 1;
    };
    text-styles = {
      Normal = textStyle colors.base05 { };
      Keyword = textStyle colors.base0E { bold = true; };
      Function = textStyle colors.base0D { };
      Variable = textStyle colors.base08 { };
      ControlFlow = textStyle colors.base0E { bold = true; };
      Operator = textStyle colors.base05 { };
      BuiltIn = textStyle colors.base0A { };
      Extension = textStyle colors.base0C { };
      Preprocessor = textStyle colors.base09 { };
      Attribute = textStyle colors.base0A { };
      Char = textStyle colors.base0B { };
      SpecialChar = textStyle colors.base0C { };
      String = textStyle colors.base0B { };
      VerbatimString = textStyle colors.base0B { };
      SpecialString = textStyle colors.base0C { };
      Import = textStyle colors.base0D { };
      DataType = textStyle colors.base0A { };
      DecVal = textStyle colors.base09 { };
      BaseN = textStyle colors.base09 { };
      Float = textStyle colors.base09 { };
      Constant = textStyle colors.base09 { bold = true; };
      Comment = textStyle colors.base03 { italic = true; };
      Documentation = textStyle colors.base03 { };
      Annotation = textStyle colors.base03 { };
      CommentVar = textStyle colors.base03 { };
      RegionMarker = (textStyle colors.base0C { }) // { background-color = colors.base01; };
      Information = (textStyle colors.base00 { }) // { background-color = colors.base0D; };
      Warning = (textStyle colors.base00 { }) // { background-color = colors.base0A; };
      Alert = (textStyle colors.base00 { bold = true; }) // { background-color = colors.base08; };
      Error = textStyle colors.base08 { underline = true; };
      Others = textStyle colors.base0C { };
    };

    editor-colors = {
      BackgroundColor = colors.base00;
      CodeFolding = colors.base01;
      BracketMatching = colors.base02;
      CurrentLine = colors.base01;
      IconBorder = colors.base00;
      IndentationLine = colors.base02;
      LineNumbers = colors.base03;
      CurrentLineNumber = colors.base05;
      MarkBookmark = colors.base0D;
      MarkBreakpointActive = colors.base08;
      MarkBreakpointReached = colors.base0B;
      MarkBreakpointDisabled = colors.base03;
      MarkExecution = colors.base0A;
      MarkWarning = colors.base09;
      MarkError = colors.base08;
      ModifiedLines = colors.base09;
      ReplaceHighlight = colors.base0B;
      SavedLines = colors.base0B;
      SearchHighlight = colors.base0A;
      TextSelection = colors.base02;
      Separator = colors.base02;
      SpellChecking = colors.base08;
      TabMarker = colors.base02;
      TemplateBackground = colors.base01;
      TemplatePlaceholder = colors.base0B;
      TemplateFocusedPlaceholder = colors.base0D;
      TemplateReadOnlyPlaceholder = colors.base08;
      WordWrapMarker = colors.base02;
    };
  };
in
{
  xdg.dataFile."org.kde.syntax-highlighting/themes/stylix.theme".text = builtins.toJSON theme;

  home.activation.kateStylixTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} \
      --file "$HOME/.config/katerc" \
      --group "KTextEditor Renderer" \
      --key "Auto Color Theme Selection" \
      --type bool false

    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} \
      --file "$HOME/.config/katerc" \
      --group "KTextEditor Renderer" \
      --key "Color Theme" \
      "${themeName}"

    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} \
      --file "$HOME/.config/katerc" \
      --group "KTextEditor Document" \
      --key "Auto Reload If Any External Changes Occurs" \
      --type bool true
  '';
}
