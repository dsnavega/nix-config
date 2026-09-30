{ ... }:
{

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = "navega";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    # .app
    casks = [
      # terminal & development
      "ghostty"
      "zed"
      "docker-desktop"
      "rstudio"
      # academic & note-taking
      "obsidian"
      "zotero"
      "libreoffice"
      # utilities
      "appcleaner"                  # .app and associated data removal
      "balenaetcher"                # Bootable ISO to USB
      "logi-options+"               # logitech software for keyboard and trackball
      "homerow"                     # keyboard driven control (vimium for macOS)
      # artificial intelligence
      "ollama-app"
      "hermes-desktop"
      "lm-studio"
      "lm-studio-bionic"
      # 3D
      "meshlab"
      # browsers
      "firefox"
      "zen"
    ];

    taps = [
      "antoniorodr/memo"
    ];

    brews = [
      "antoniorodr/memo/memo"
      "hermes-agent"
    ];
  };
}
