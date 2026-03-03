return {
    'goolord/alpha-nvim',
    dependencies = {
        'nvim-mini/mini.icons',
        'nvim-lua/plenary.nvim'
    },
    config = function ()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
        "                          WELCOME TO",
        "    __ \\    \\  |  ____|  __ \\ _ _|   ___|  __ )    _ \\ \\ \\  / ",
        "   / _` |  |\\/ |  __|    |   |  |   |      __ \\   |   | \\  /  ",
        "  | (   |  |   |  |      |   |  |   |      |   |  |   |    \\  ",
        " \\ \\__,_| _|  _| _____| ____/ ___| \\____| ____/  \\___/  _/\\_\\ ",
        "  \\____/",
        }

        -- Set menu
        dashboard.section.buttons.val = {
            dashboard.button( "n", "  > New file" , ":ene <BAR> startinsert <CR>"),
            dashboard.button( "e", "  > Sidebar" , ":Neotree toggle<CR>"),
            dashboard.button( "f", "  > Find file", ":cd $PWD | Telescope find_files<CR>"),
            dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
            dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
            dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
        }

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])
    end
}
