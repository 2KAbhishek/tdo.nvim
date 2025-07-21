local plenary_dir = os.getenv('PLENARY_DIR') or '/tmp/plenary.nvim'
local is_not_a_directory = vim.fn.isdirectory(plenary_dir) == 0
if is_not_a_directory then
    vim.fn.system({ 'git', 'clone', 'https://github.com/nvim-lua/plenary.nvim', plenary_dir })
end

vim.opt.rtp:append('.')
vim.opt.rtp:append(plenary_dir)

package.preload['pickme'] = function()
    return {
        select_file = function() end,
        pick = function() end,
    }
end

vim.cmd('runtime plugin/plenary.vim')
require('plenary.busted')
