{ ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = false;

    settings = {
      number = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      autoindent = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      mouse = "a";
    };

    extraConfig = ''
      set relativenumber
      set cursorline
      set scrolloff=8
      set signcolumn=yes
      set nowrap
      set splitbelow
      set splitright
      set undofile

      syntax on
      filetype plugin indent on
    '';
  };
}
