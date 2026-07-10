{ pkgs, ... }:
{
  # Configure portal system-wide. Not in home!!!
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    # configPackages = with pkgs; [
    #   xdg-desktop-portal-gnome
    #   xdg-desktop-portal-gtk
    # ];
    # Don't generate service files. We've done so below.
    config = {
      common.default = [ "gnome" ];
    };
  };
  # Needed for git-credential-manger libsecret
  services.gnome.gnome-keyring.enable = true;
}
