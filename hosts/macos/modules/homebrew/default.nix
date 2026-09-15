{ inputs, self, ... }:
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
      # terminal & zed
      "ghostty"
      "zed"
      # academic & note-taking
      "obsidian"
      "zotero"
      "libreoffice"
      # utilities
      "appcleaner"          # .app and associated data removal
      "balenaetcher"        # Bootable ISO to USB
      "logi-options+"       # logitech software for keyboard and trackball
      "homerow"             # keyboard driven control (vimium for macOS)
      # ai, llm and agents
      "ollama-app"
      "hermes-desktop"
      "lm-studio"
      "lm-studio-bionic"
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
