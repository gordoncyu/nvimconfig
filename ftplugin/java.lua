local root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
local mason_lsp_install_location

if os.getenv("HOME") then
    mason_lsp_install_location = os.getenv("HOME") .. "/.local/share/nvim/mason"
else
    vim.notify("Could not find HOME env var for finding mason lsp install location", vim.log.levels.ERROR)
    return
end

local bundles = vim.split(vim.fn.glob(mason_lsp_install_location .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), '\n')

vim.list_extend(bundles, vim.split(vim.fn.glob(mason_lsp_install_location .. "/packages/java-test/extension/server/*.jar", 1), '\n'))

local config = {
    cmd = {
        mason_lsp_install_location .. "/bin/jdtls", -- This should be the full path to your jdtls binary
        '-data', root_dir,
    },
    init_options = {
        bundles = bundles,
        root_dir = root_dir,
    },
}

require('jdtls').start_or_attach(config)

