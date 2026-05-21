{
  perSystem =
    { self', pkgs, ... }:
    {
      devshells.default = {
        devshell.motd = "";
        packages = with pkgs; [
          # general
          watchexec
          # language servers
          typos-lsp
          nixd
          vscode-json-languageserver
          yaml-language-server
          dhall-lsp-server
          # custom packages
          self'.packages.processes
          (pkgs.writeShellApplication {
            name = "ide";
            runtimeInputs = [ pkgs.zellij ];
            text = "zellij attach zwamvrienden || zellij --session zwamvrienden --new-session-with-layout zellij.kdl";
          })
          (pkgs.writeShellApplication {
            name = "newide";
            runtimeInputs = [ pkgs.zellij ];
            text = "zellij delete-session --force zwamvrienden && ide";
          })
        ];
      };

      process-compose.processes = {
        settings.processes = {
          format.command = "watchexec nix fmt";
        };
        cli.options.no-server = true;
      };

      treefmt = {
        programs = {
          # general
          prettier = {
            enable = true;
            settings = {
              embeddedLanguageFormatting = "auto";
              proseWrap = "preserve";
            };
          };
          # nix
          nixfmt.enable = true;
          nixfmt.strict = true;
          statix.enable = true;
          deadnix.enable = true;
          # data formats
          jsonfmt.enable = true;
          yamlfmt.enable = true;
          dhall.enable = true;
          dhall.lint = true;
        };
      };
    };
}
