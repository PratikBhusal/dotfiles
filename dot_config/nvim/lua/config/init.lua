-- `mapleader` and `maplocalleader` must be set before
-- loading lazy.nvim so that mappings are correct.

-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO: Slowly move plugins over to using lazy.nvim
require('config.lazy-init')
