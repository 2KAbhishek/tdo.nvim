local config = require('tdo.config').config

-- Only copy the tdo module and replace the calls to config with your own values for lazy loading
local tdo = {
    function()
        local update_frequency = config.lualine.update_frequency or 300
        if not vim.g.tdo_last_update or (os.time() - vim.g.tdo_last_update) > update_frequency then
            vim.g.tdo_last_update = os.time()
            local result = vim.fn.system('tdo pending')
            vim.g.tdo_count = tonumber(result:match('%d+')) or 0
        end
        return vim.g.tdo_count or 0
    end,
    icon = ' ',
    color = { fg = '#8BCD5B', gui = 'bold' },
    cond = function()
        local show_everywhere = config.lualine.only_show_in_notes or false
        if show_everywhere then
            return true
        end
        local notes_dir = vim.env.NOTES_DIR
        if not notes_dir then
            return false
        end
        local current_file = vim.fn.expand('%:p')
        return current_file:find(vim.fn.expand(notes_dir), 1, true) == 1
    end,
}

return tdo
