{ config, pkgs, inputs, lib, ... }:

# https://github.com/nix-community/home-manager/issues/815#issuecomment-537442524
let
  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';
  plugins = with pkgs.vimPlugins; [
    nerdtree
    pkgs.vimPlugins.vim-nix
    pkgs.vimPlugins.typescript-vim
    pkgs.vimPlugins.onedark-vim
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "which-key";
      version = "latest";
      src = inputs.nvim-which-key;
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "nerd-commenter";
      version = "latest";
      src = inputs.nvim-nerd-commenter;
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc.nvim";
      version = "latest";
      src = inputs.nvim-coc;
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc-git";
      version = "latest";
      src = inputs.nvim-coc-git;
      buildInputs = [ pkgs.nodejs pkgs.yarn ];
      preInstall = ''
        yarn install --frozen-lockfile || true
        npm run prepare
      '';
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc-json";
      version = "latest";
      src = inputs.nvim-coc-json;
      buildInputs = [ pkgs.nodejs pkgs.yarn ];
      preInstall = ''
        yarn install --frozen-lockfile || true
        npm run prepare
      '';
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc-prettier";
      version = "latest";
      src = inputs.nvim-coc-prettier;
      buildInputs = [ pkgs.nodejs pkgs.yarn ];
      preInstall = ''
        yarn install --frozen-lockfile || true
        npm run prepare
      '';
    })
    (pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc-tsserver";
      version = "latest";
      src = inputs.nvim-coc-tsserver;
      buildInputs = [ pkgs.nodejs pkgs.yarn ];
      preInstall = ''
        yarn install --frozen-lockfile || true
        npm run prepare
      '';
    })
  ];
in {
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    extraConfig = ''
      " # Display
      set relativenumber
      syntax on

      ${builtins.concatStringsSep "\n" (map loadPlugin plugins)}

      colorscheme onedark
      set termguicolors
      set winblend=15

      let g:leaderGuide_vspace = 5
      let g:leaderGuide_vertical = 1
      let g:lmap = {}

      " Interactive keymaps
      imap jj <Esc>

      " Set leader
      let mapleader = "\<space>"
      nnoremap <space> <Nop>
      map <space> <leader>

      " Language
      let g:lmap.l = {'name' : 'language'}

      let g:lmap.l.p = 'prettier'
      nmap <leader>lp :CocCommand prettier.formatFile<CR>

      let g:lmap.l.r = 'restart lang server'
      autocmd FileType javascript,javascriptreact,typescript,typescriptreact nmap <leader>lr :CocCommand tsserver.restart<CR>

      " Commenting
      let g:NERDSpaceDelims = 1
      let g:NERDCreateDefaultMappings = 0
      let g:lmap.c = {'name' : 'commenter'}

      let g:lmap.c.c = 'toggle'
      nmap <leader>cc <plug>NERDCommenterToggle
      let g:lmap.c.w = 'comment (write)'
      nmap <leader>cw <plug>NERDCommenterComment
      let g:lmap.c.d = 'uncomment (delete)'
      nmap <leader>cd <plug>NERDCommenterUncomment

      " Other maps
      map <C-N> :NERDTreeToggle<CR>
      map <A-N> :NERDTreeFocus<CR>

      call leaderGuide#register_prefix_descriptions("<space>", "g:lmap")
      nnoremap <silent> <leader> :<c-u>LeaderGuide '<space>'<CR>

      let g:wmap = {}
      "call leaderGuide#register_prefix_descriptions("<c-w>", "g:wmap")
      "map <silent> <c-w> :<c-u>LeaderGuide '<c-w>'<CR>
    '';
  };

  home.file.".config/nvim/coc-settings.json".text = builtins.toJSON {
    "coc.preferences.formatOnSaveFiletypes" = [
      "css"
      "markdown"
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
      "json"
      "graphql"
    ];
  };
}

