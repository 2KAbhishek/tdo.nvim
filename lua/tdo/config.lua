local M = {}

M.config = {
    use_new_command = false,
}

M.setup = function(user_config)
    M.config = vim.tbl_deep_extend('force', M.config, user_config or {})
end

return M
