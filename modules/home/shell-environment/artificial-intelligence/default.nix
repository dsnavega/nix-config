{ inputs, ...}: {
  home.packages = with llm-agents; [
    claude
    opencode
    hermes-agent
  ];
}
