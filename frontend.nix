{
  perSystem =
    { pkgs, lib, ... }:
    {
      devshells.default = {
        packages = with pkgs; [
          hugo
          nodejs
          dart-sass
          (pkgs.writeShellApplication {
            name = "favicon";
            runtimeInputs = [
              pkgs.inkscape
              pkgs.imagemagick
            ];
            text = ''
              cp assets/favicon.svg static/favicon.svg
              mkdir -p static/favicon
              inkscape assets/favicon.svg -w  16 -h  16 -o static/favicon/16.png
              inkscape assets/favicon.svg -w  32 -h  32 -o static/favicon/32.png
              inkscape assets/favicon.svg -w  64 -h  64 -o static/favicon/64.png
              inkscape assets/favicon.svg -w 128 -h 128 -o static/favicon/128.png
              inkscape assets/favicon.svg -w 256 -h 256 -o static/favicon/256.png
              inkscape assets/favicon.svg -w 512 -h 512 -o static/favicon/512.png
              inkscape assets/favicon.svg -w 180 -h 180 -o static/favicon/180.png
              inkscape assets/favicon.svg -w 192 -h 192 -o static/favicon/192.png
              magick static/favicon/16.png \
                     static/favicon/32.png \
                     static/favicon/64.png \
                     static/favicon/128.png \
                     static/favicon/256.png \
                     static/favicon.ico
            '';
          })
        ];
      };

      process-compose.processes = {
        settings.processes = {
          hugo = {
            command = "hugo server --disableFastRender";
          };
        };
      };

      treefmt = {
        programs = {
          prettier.excludes = [ "*.html" ]; # contains hugo templates
        };
        settings.formatter = {
          stylint = {
            command = "${lib.getExe pkgs.stylelint}";
            options = [ "--fix" ];
            includes = [
              "*.css"
              "*.less"
              "*.scss"
              "*.sass"
            ];
          };
        };
        settings.excludes = [
          "node_modules/*"
          "public/*"
          "resources/*"
          "assets/sass/pico/*"
        ];
      };
    };
}
