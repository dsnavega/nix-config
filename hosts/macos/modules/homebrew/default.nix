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
      # terminal
      "ghostty"
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
