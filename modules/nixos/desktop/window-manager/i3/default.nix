{ pkgs, ... }:
{

  services.xserver = {

    desktopManager = {
      xterm = {
        enable = false;
      };
    };

    windowManager = {
      i3 = {
        enable = true;
        extraPackages = with pkgs; [
          # i3wm & X11 utilities
          i3status
          i3lock-color
          shared-mime-info
          xss-lock
          xidlehook
          xauth
          xhost
          xrandr
          arandr
          xsettingsd
          xrdb
          xprop
          xset
          xsetroot
          hsetroot
          xev
          xclip
          xsel
          xinput
          xkbcomp
          xkbutils
          # minimal utilities
          dmenu-rs-enable-plugins
          mpv
          feh
          imv
          zathura
          clipse-x11
          # kdePackages
          kdePackages.kate
          kdePackages.dolphin
          kdePackages.dolphin-plugins
          kdePackages.ark
          kdePackages.konsole
          kdePackages.gwenview
          kdePackages.okular
          kdePackages.dragon
          kdePackages.elisa
          kdePackages.kservice
          kdePackages.kio
          kdePackages.kded
          kdePackages.kio-admin
          kdePackages.kio-extras
          kdePackages.kio-fuse
          kdePackages.kwallet
          kdePackages.kwalletmanager
          kdePackages.kwallet-pam
          kdePackages.polkit-kde-agent-1
          kdePackages.qqc2-desktop-style
          qt6Packages.qtstyleplugin-kvantum
        ];
      };
    };
  };

  xdg.autostart.enable = true;
  xdg.menus.enable = true;
  xdg.icons.enable = true;
  programs.dconf.enable = true;

  environment.etc."xdg/menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
     "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <DefaultMergeDirs/>
      <Menu>
        <Name>AudioVideo</Name>
        <Include><Category>AudioVideo</Category></Include>
      </Menu>
      <Menu>
        <Name>Development</Name>
        <Include><Category>Development</Category></Include>
      </Menu>
      <Menu>
        <Name>Education</Name>
        <Include><Category>Education</Category></Include>
      </Menu>
      <Menu>
        <Name>Game</Name>
        <Include><Category>Game</Category></Include>
      </Menu>
      <Menu>
        <Name>Graphics</Name>
        <Include><Category>Graphics</Category></Include>
      </Menu>
      <Menu>
        <Name>Network</Name>
        <Include><Category>Network</Category></Include>
      </Menu>
      <Menu>
        <Name>Office</Name>
        <Include><Category>Office</Category></Include>
      </Menu>
      <Menu>
        <Name>Settings</Name>
        <Include><Category>Settings</Category></Include>
      </Menu>
      <Menu>
        <Name>System</Name>
        <Include><Category>System</Category></Include>
      </Menu>
      <Menu>
        <Name>Utility</Name>
        <Include><Category>Utility</Category></Include>
      </Menu>
    </Menu>
  '';

}
