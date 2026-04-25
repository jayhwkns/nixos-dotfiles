{ pkgs, ... }:
let
  anyrunCss = /*css*/ ''
      @define-color accent #df7d00;
      @define-color bg-color #191616;
      @define-color fg-color #e6e6e6;
      @define-color desc-color #c7c7c7;

      window {
        background: transparent;
      }

      box.main {
        padding: 5px;
        margin: 10px;
        border-radius: 0;
        border: 2px solid @accent;
        background-color: rgba(24, 22, 22, 0.85);
        box-shadow: 0 0 5px black;
      }


      text {
        min-height: 30px;
        padding: 5px;
        border-radius: 0;
        color: @fg-color;
        font-family: "VictorMono NF";
      }

      .matches {
        background-color: rgba(0, 0, 0, 0);
        border-radius: 10px;
      }

      box, list, label {
        font-family: "VictorMono NF";
      }

      box.plugin:first-child {
        margin-top: 5px;
      }

      box.plugin.info {
        min-width: 200px;
      }

      list.plugin {
        background-color: rgba(0, 0, 0, 0);
      }

      label.match {
        color: @fg-color;
      }

      label.match.description {
        font-size: 10px;
        color: @desc-color;
      }

      label.plugin.info {
        font-size: 14px;
        color: @fg-color;
      }

      .match {
        background: transparent;
      }

      .match:selected {
        border-left: 4px solid @accent;
        background: transparent;
      }
    '';
in
{
  programs.anyrun = {
    enable = true;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.45; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
      ];
    };
    extraCss = anyrunCss;
  };
}
