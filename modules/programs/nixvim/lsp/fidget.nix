{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.programs.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim.plugins.fidget = {
      enable = true;

      logger = {
        level = "warn";
        floatPrecision = 0.01;
      };

      progress = {
        pollRate = 0;

        suppressOnInsert = true;
        ignoreDoneAlready = false;
        ignoreEmptyMessage = false;

        clearOnDetach = ''
          function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end
        '';

        notificationGroup = "function(msg) return msg.lsp_client.name end";

        display = {
          progressIcon = {
            pattern = "dots";
            period = 1;
          };
        };
      };

      notification = {
        overrideVimNotify = true;

        window.winblend = 0;
      };
    };
  };
}
