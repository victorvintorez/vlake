{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.cli.fish;

  inherit (config.vlake.system) username;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) submodule;
  inherit (lib.meta) mkIf mkMerge getExe hiPrio;
in {
  options.vlake.cli.fish = {
    enable = mkEnableOption "Enable Fish Shell";
    replace = mkOption {
      description = "Use Replaced CLI Utils";
      type = submodule {
        enableAll = mkEnableOption "Enable all replacement CLI Utils";
        coreutils = mkEnableOption "Use Uutils instead of GNU Coreutils";
        cat = mkEnableOption "Use Bat instead of Cat";
        diff = mkEnableOption "Use Delta instead of Diff";
        df = mkEnableOption "Use Dysk instead of Df";
        du = mkEnableOption "Use Dust instead of Du";
        find = mkEnableOption "Use Fd instead of Find";
        grep = mkEnableOption "Use RipGrep instead of Grep";
        ls = mkEnableOption "Use Eza instead of Ls";
        ping = mkEnableOption "Use Gping instead of Ping";
      };
    };
    plugins = mkOption {
      description = "Enable Fish Plugins";
      type = submodule {
        enableAll = mkEnableOption "Enable all Fish Plugins";
        autopair = mkEnableOption "Enable the Fish Autopair Plugin";
        fzf = mkEnableOption "Enable the Fish Fzf Plugin";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
      shellAliases = {
        cat =
          mkIf (cfg.replace.enableAll || cfg.replace.cat) "${getExe pkgs.bat}";
        diff = mkIf (cfg.replace.enableAll || cfg.replace.diff)
          "${getExe pkgs.delta}";
        df =
          mkIf (cfg.replace.enableAll || cfg.replace.df) "${getExe pkgs.dysk}";
        du =
          mkIf (cfg.replace.enableAll || cfg.replace.du) "${getExe pkgs.dust}";
        find = mkIf (cfg.replace.enableAll || cfg.replace.find)
          "${getExe pkgs.fd} -u";
        grep = mkIf (cfg.replace.enableAll || cfg.replace.grep)
          "${getExe pkgs.ripgrep}";
        ls = mkIf (cfg.replace.enableAll || cfg.replace.ls)
          "${getExe pkgs.eza} -l --icons --group-directories-first";
        ping = mkIf (cfg.replace.enableAll || cfg.replace.ping)
          "${getExe pkgs.gping}";
      };
    };

    hjem.users.${username}.files.".config/fish/config.fish".text = ''
      if status is-interactive
       	set -g fish_greeting '\'
      end

      ${mkIf (cfg.plugins.enableAll || cfg.plugins.fzf) ''
        set fzf_preview_dir_cmd eza --all --color=always
        set fzf_fd_opts --hidden
      ''}
    ''; # TODO: write copyfile and copytext functions using wl-clipboard-rs

    environment.systemPackages = mkMerge [
      (mkIf (cfg.replace.enableAll || cfg.replace.coreutils)
        (with pkgs; [ (hiPrio uutils-coreutils-noprefix) ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.cat) (with pkgs; [ bat ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.diff) (with pkgs; [ delta ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.df) (with pkgs; [ dysk ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.du) (with pkgs; [ dust ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.find) (with pkgs; [ fd ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.grep)
        (with pkgs; [ ripgrep ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.ls) (with pkgs; [ eza ]))
      (mkIf (cfg.replace.enableAll || cfg.replace.ping) (with pkgs; [ gping ]))
      (mkIf (cfg.plugins.enableAll || cfg.plugins.autopair)
        (with pkgs.fishPlugins; [ fishplugin-autopair ]))
      (mkIf (cfg.plugins.enableAll || cfg.plugins.fzf) (with pkgs.fishPlugins;
        [ fishplugin-fzf.fish ])) # maybe replace with fishplugin-fifc
    ];
  };
}
