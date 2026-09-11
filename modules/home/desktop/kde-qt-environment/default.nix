{ ... }: {
  imports = [
    ./kde.nix
    ./mimeapps.nix
    ./browser/qutebrowser.nix
    ./screenshot/flameshot.nix
    ./terminal/konsole.nix
    ./text-editor/kate.nix
  ];
}
