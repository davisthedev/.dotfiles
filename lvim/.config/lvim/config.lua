require("user.plugins").config()

lvim.colorscheme = "catppuccin"
lvim.builtin.lualine.options.theme = "catppuccin"
lvim.builtin.nvimtree.setup.update_focused_file.update_root = false
lvim.builtin.nvimtree.setup.prefer_startup_root = true
lvim.builtin.nvimtree.setup.sync_root_with_cwd = false
lvim.builtin.nvimtree.setup.actions.change_dir.enable = false

-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<leader>lc"] = "<cmd>lua require'user.functions'.logVariable()<CR>"

lvim.keys.insert_mode["jk"] = "<ESC>"

lvim.keys.visual_mode["J"] = ":m '>+1<CR>gv=gv"
lvim.keys.visual_mode["K"] = ":m '<-2<CR>gv=gv"
