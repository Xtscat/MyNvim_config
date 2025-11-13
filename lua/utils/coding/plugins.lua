-- utils/coding/plugins.lua

return {
    {
        "CRAG666/code_runner.nvim",
        config = function()
            require("utils.coding.config").code_runner_config()
            require("utils.coding.keymaps").code_runner_keymaps()
        end
    },
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        config = function()
            require("utils.coding.config").leetcode_config()
            -- require("utils.coding.keymaps").leetcode_keymaps()
        end
    }
}
