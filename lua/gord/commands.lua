vim.api.nvim_create_user_command('WE', function ()
    vim.cmd('w')
    vim.cmd('e')
end,
{nargs=0})

vim.cmd([[
" Define a new command 'BDKeepPane' that deletes the current buffer
" without closing the window or pane.
" in vimscript because doing it in lua screwed over vim-tmux-navigator
" dang vimscript syntax highlighting within lua files
function! DeleteBufferKeepPane()
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
        execute 'bdelete' l:current_buffer
    else
        echo "No other buffer found to switch to; buffer not deleted."
    endif
endfunction

command! BD call DeleteBufferKeepPane()
]])
