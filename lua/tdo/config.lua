local M = {}

---@class TdoCompletionConfig
---@field offsets string[] Custom offsets / date expressions for completion
---@field ignored_files string[] Files/directories to ignore in completions

---@class TdoCacheConfig
---@field timeout number Completion cache timeout in milliseconds
---@field max_entries number Maximum number of cached completion entries

---@class TdoLualineConfig
---@field update_frequency number How frequently to update the pending todo count in lualine
---@field only_show_in_notes boolean Whether to show the lualine component only in notes buffers

---@class TdoConfig
---@field use_new_command boolean Use the new unified `Tdo` command
---@field add_default_keybindings boolean Add default keybindings for the plugin
---@field completion TdoCompletionConfig Completion configuration
---@field cache TdoCacheConfig Cache configuration
---@field lualine TdoLualineConfig Lualine integration configuration

---@type TdoConfig
M.config = {
    use_new_command = false,
    add_default_keybindings = true,
    completion = {
        offsets = {},
        ignored_files = { 'README.md', 'templates' },
    },
    cache = {
        timeout = 5000,
        max_entries = 100,
    },
    lualine = {
        update_frequency = 300,
        only_show_in_notes = false,
    },
}

---Setup function to merge user config with defaults
---@param user_config? TdoConfig User configuration to merge with defaults
M.setup = function(user_config)
    M.config = vim.tbl_deep_extend('force', M.config, user_config or {})
end

return M
