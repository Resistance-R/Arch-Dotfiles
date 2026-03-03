local mapKey = require("utils.keyMapper").mapKey

-- Neotree toggle
mapKey('<leader>e', ':Neotree toggle<cr>')

-- pane navigation
mapKey('<C-h>', '<C-w>h') -- left
mapKey('<C-j>', '<C-w>j') -- down 
mapKey('<C-k>', '<C-w>k') -- up
mapKey('<C-l>', '<C-w>l') -- right

-- clear search hl
mapKey('<leader>h', ':nohlsearch<CR>')

-- select all
mapKey('<leader>a', 'gg0vG$')
