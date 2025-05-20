vim.api.nvim_create_user_command('WE', function ()
    vim.cmd('w')
    vim.cmd('e')
end,
{nargs=0})

vim.api.nvim_create_user_command("WP", function(opts)
    local expanded = vim.fn.expand(opts.args)
    local dirname = vim.fn.fnamemodify(expanded, ":h")
    if vim.fn.isdirectory(dirname) == 0 then
        vim.fn.mkdir(dirname, "p")
    end
    vim.cmd("write " .. vim.fn.fnameescape(expanded))
end, {
    nargs = 1,
    complete = "file",
})

vim.api.nvim_create_user_command("EP", function(opts)
    local expanded = vim.fn.expand(opts.args)
    local dirname = vim.fn.fnamemodify(expanded, ":h")
    if vim.fn.isdirectory(dirname) == 0 then
        vim.fn.mkdir(dirname, "p")
    end
    vim.cmd("edit " .. vim.fn.fnameescape(expanded))
end, {
    nargs = 1,
    complete = "file",
})

vim.api.nvim_create_user_command("WEP", function(opts)
    local expanded = vim.fn.expand(opts.args)
    local dirname = vim.fn.fnamemodify(expanded, ":h")
    if vim.fn.isdirectory(dirname) == 0 then
        vim.fn.mkdir(dirname, "p")
    end
    vim.cmd("write " .. vim.fn.fnameescape(expanded))
    vim.cmd("edit " .. vim.fn.fnameescape(expanded))
end, {
    nargs = 1,
    complete = "file",
})

vim.cmd([[
" in vimscript because doing it in lua screwed over vim-tmux-navigator
" dang vimscript syntax highlighting within lua files
" Define a function to delete the current buffer while keeping the pane, with an option to force deletion.
function! DeleteBufferKeepPane(force) range
    if &modified && a:force == 0
        echoerr "Buffer is modified. Use BD! to force deletion."
        return
    endif

    " Store the current buffer number.
    let l:current_buffer = bufnr('%')

    " Find a buffer to switch to.
    let l:buffer_to_switch = -1
    for l:buf in range(1, bufnr('$'))
        if l:buf != l:current_buffer && buflisted(l:buf)
            let l:buffer_to_switch = l:buf
            break
        endif
    endfor

    " If an alternative buffer was found, switch to it and delete the original.
    if l:buffer_to_switch != -1
        execute 'buffer' l:buffer_to_switch
        if a:force
            execute 'bdelete!' l:current_buffer
        else
            execute 'bdelete' l:current_buffer
        endif
    else
        echo "No other buffer found to switch to; buffer not deleted."
    endif
endfunction

" Define a command that checks for a bang. It will pass 1 to the function if the bang is present.
command! -bang BD call DeleteBufferKeepPane(<bang>0 == '' ? 0 : 1)
]])

local function add_unwritten_buffers_to_qfl()
    local buffers = vim.api.nvim_list_bufs()
    local qf_list = {}
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_get_option(buf, 'modified') then
            local buftype = vim.bo[buf].buftype
            if buftype == '' or buftype == 'acwrite' then
                print"+actual1"
                local bufname = vim.api.nvim_buf_get_name(buf)
                table.insert(qf_list, {
                    bufnr = buf,
                    filename = bufname,
                    lnum = 1,
                    text = "Unwritten buffer: " .. bufname
                })
            end
        end
    end

    if #qf_list > 0 then

        vim.fn.setqflist(qf_list, 'r')
        vim.cmd('copen')
    else
        print("No unwritten buffers found.")
    end
end

vim.api.nvim_create_user_command('Cleanunwr', add_unwritten_buffers_to_qfl, {})

local function would_qa_fail()
    -- Check for modified buffers
    local has_modified = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
            has_modified = true
            break
        end
    end
    
    -- Check for running jobs/terminals
    local has_running_jobs = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == 'terminal' then
            local job_id = vim.b[buf].terminal_job_id
            if job_id and vim.fn.jobwait({job_id}, 0)[1] == -1 then
                has_running_jobs = true
                break
            end
        end
    end
    
    -- Check for unsaved files without names (like [No Name] buffers)
    local has_unnamed_modified = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
            local name = vim.api.nvim_buf_get_name(buf)
            if name == "" then
                has_unnamed_modified = true
                break
            end
        end
    end
    
    return has_modified or has_running_jobs or has_unnamed_modified
end

vim.api.nvim_create_user_command('QA', function()

    if would_qa_fail() then
        -- If would fail, run cleanunwr and try again
        print("Quit failed, unwritten buffers sent to quickfixlist")
        add_unwritten_buffers_to_qfl()
    else
        vim.cmd('qa')
    end
end, {
    desc = 'Quit all, run cleanunwr if needed'
})

-- Create alias for Qa as well
vim.api.nvim_create_user_command('Qa', function()
    vim.cmd('QA')
end, {
    desc = 'Quit all, run cleanunwr if needed (alias)'
})

