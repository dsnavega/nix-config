{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0";
      OLLAMA_ORIGINS = "*";
      OLLAMA_CONTEXT_LENGTH = "131072";
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
      OLLAMA_NUM_PARALLEL = "1";
    };
  };
  environment.systemPackages = with pkgs; [
    # tools (llm-agents.nix overlay: daily-updated agent builds)
    llm-agents.claude-code
    llm-agents.opencode
    llm-agents.opencode-desktop
    llm-agents.hermes-agent
    llm-agents.hermes-desktop
    llm-agents.hermes-one
    llm-agents.hermes-hud
    # mcp
    mcp-nixos
  ];
}
