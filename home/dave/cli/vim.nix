{ ... }:

{
  programs.vim = {
    enable = true;

    extraConfig = ''
      " Apariencia
      syntax on
      set number
      set relativenumber
      set cursorline

      " Indentación
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set autoindent
      set smartindent

      " Búsqueda
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch

      " Navegación
      set mouse=a
      set scrolloff=8
      set signcolumn=yes
      set nowrap

      " Ventanas
      set splitbelow
      set splitright

      " Ficheros
      set undofile

      filetype plugin indent on
    '';
  };
}
