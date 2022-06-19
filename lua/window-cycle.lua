local api = vim.api

local M = {}

local buf_start = 1

local function buf_count() return #api.nvim_list_bufs(); end

local function win_count() return #api.nvim_list_wins(); end

local function win_at(num) return api.nvim_list_wins()[num]; end

-- neovim buffer status is a mess, the loaded and valid status doesn't
-- guarantee anything.
function M.report()
    -- api.nvim_win_is_valid(i)
    local bufs = api.nvim_list_bufs();
    local wins = api.nvim_list_wins();

    print("buf count ".. #bufs)
    print("win count ".. #wins)
end

local function winpopu ()
    if buf_start >= buf_count() then
        return
    end
    local bufleft = buf_count() - buf_start + 1;
    print(string.format("start to end: %d, %d", buf_start, bufleft));
    for k, win in pairs(api.nvim_list_wins()) do
        api.nvim_win_set_buf(win, buf_start)
        --print(string.format("set win %s with buf %d", k, buf_start))
        buf_start = buf_start +1
        if k == bufleft then
            return
        end
    end
end

function M.next()
    buf_start = api.nvim_win_get_buf(win_at(win_count())) +1
    winpopu()
end

function M.previous()
    local x = api.nvim_win_get_buf(win_at(1))
    x = x - win_count()
    buf_start = math.max(1, x)
    winpopu();
end

function M.reset()
    buf_start = 1
    winpopu()
end

return M
