vim.api.nvim_create_user_command('WE', function ()
    vim.cmd('w')
    vim.cmd('e')
end,
{nargs=0})

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
