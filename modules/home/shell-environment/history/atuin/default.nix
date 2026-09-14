{ ... }:
{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      inline_height = 20;
      show_help = true;
      show_tabs = true;

      # Self-hosted sync server on cogitator (modules/nixos/.../services/atuin),
      # reached by its Tailscale MagicDNS name. Plain HTTP is fine inside the
      # tailnet, and history is encrypted client-side before upload anyway.
      sync_address = "http://cogitator:8888";
      auto_sync = true;
      sync_frequency = "5m";
    };
  };
}
