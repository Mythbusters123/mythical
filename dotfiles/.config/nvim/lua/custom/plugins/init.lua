-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                theme = "onedark",
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        "m4xshen/smartcolumn.nvim",
        opts = {},
    },
    {
        "goolord/alpha-nvim",
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons_provider = "devicons"
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
                dashboard.button("r", "  Recents", ":Telescope oldfiles<CR>"),
            }
            require("alpha").setup(
                startify.config
            )
        end
    }
}
