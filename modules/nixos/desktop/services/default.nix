{ ... }:
{
  services.libinput.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  # NOTE: udiskie is the tray/automount frontend and exists only as a
  # home-manager option (services.udiskie), not a NixOS one -- it belongs
  # in the desktop home profile, alongside the rest of the session.

  # Tracks which MPRIS player was last active, so `playerctl next/play-pause`
  # from the i3 media keybinds acts on the one you were actually using instead
  # of picking arbitrarily between firefox/spotify/mpv. Runs as a systemd user
  # service and installs playerctl itself, so the package leaves
  # system/packages/hardware.
  #
  # It does NOT grab media keys -- the XF86Audio* binds in the i3 config still
  # do that. Handling keys outside the WM would mean services.actkbd or
  # triggerhappy, which run outside the session and cannot reach its D-Bus bus
  # without extra plumbing.
  services.playerctld.enable = true;
}
