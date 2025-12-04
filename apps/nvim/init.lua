require("config.lazy")

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cindent = true

vim.opt.wrap = false

vim.opt.undofile = true

vim.api.nvim_set_keymap('n', '<C-M-l>', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true })

vim.cmd([[
    augroup vimrc-incsearch-highlight
        autocmd!
        autocmd CmdlineEnter /,\? :set hlsearch
        autocmd CmdlineLeave /,\? :set nohlsearch
    augroup END
]])

vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
    end,
    desc = "Highlight LSP references",
})
