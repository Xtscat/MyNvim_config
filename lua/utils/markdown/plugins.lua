-- utils/markdown/plugins.lua

return {
    {
        "yutanagano/smark.nvim",
        ft = { "markdown", "text" },
        config = function()
            require("utils.markdown.config").smark_config()
            require("utils.markdown.keymaps").smark_keymaps()
        end
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        config = function()
            require("utils.markdown.config").render_markdown_config()
        end
    }
}
