-- ai/config.lua

local M = {}

function M.codecompanion_config()
    require('copilot').setup({})
    require('codecompanion').setup({
        strategies = {
            chat = {
                adapter = {
                    name = 'copilot',
                    model = 'gpt-5-mini'
                },
                keymaps = {
                    send = {
                        modes = { n = "<c-k>", i = "<c-k>" },
                    },
                    close = {
                        modes = { n = "<leader>xo", i = "<leder>xo" },
                    },
                },
            },
            inline = {
                adapter = {
                    name = 'copilot',
                    model = 'gemini-2.5-pro'
                },
                keymaps = {
                    accept_change = {
                        modes = { n = "ga" },
                        description = "Accept the suggested change",
                    },
                    reject_change = {
                        modes = { n = "gr" },
                        description = "Reject the suggested change",
                    },
                },
            },
            cmd = {
                adapter = {
                    name = 'copilot',
                    model = 'gpt-4.1-2025-04-14'
                },
            },
        },
        display = {
            chat = {
                window = {
                    position = "right",
                    width = 0.3
                }
            }
        },
        adapters = {
            http = {
                opts = {
                    -- show_defaults 会导致copilot不能正常工作
                    show_defaults = false,
                    show_model_choices = true,
                    -- log_level = "DEBUG",
                    language = "Chinese"
                },

            }
        },
    })
end

return M
