require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, {desc="stage git hunk"})
    map('n', '<leader>hr', gs.reset_hunk, {desc="reset git hunk"})
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="git stage visual selection"})
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="git reset visual selection"})
    map('n', '<leader>hS', gs.stage_buffer, {desc="git stage whole buffer"})
    map('n', '<leader>hu', gs.undo_stage_hunk, {desc="unstage git hunk"})
    map('n', '<leader>hR', gs.reset_buffer, {desc="git reset whole buffer"})
    map('n', '<leader>hp', gs.preview_hunk, {desc="preview git hunk"})
    map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc="git blame current line"})
    map('n', '<leader>htb', gs.toggle_current_line_blame, {desc="toggle git blame"})
    map('n', '<leader>hd', gs.diffthis, {desc="git diff current file against staged"})
    map('n', '<leader>hD', function() gs.diffthis('~') end, {desc="git diff current file against current commit"})
    map('n', '<leader>htd', gs.toggle_deleted, {desc="toggle display of deleted hunk inline with buffer"})

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc="select git hunk"})
  end
}
