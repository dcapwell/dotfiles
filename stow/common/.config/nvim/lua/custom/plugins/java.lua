--return {
--  'nvim-java/nvim-java',
--  config = function()
--    require('java').setup()
--    vim.lsp.enable 'jdtls'
--  end,
--}

--return {
--  'nvim-java/nvim-java',
--  config = false,
--  dependencies = {
--    {
--      'neovim/nvim-lspconfig',
--      opts = {
--        servers = {
--          jdtls = {
--            -- Your custom jdtls settings goes here
--          },
--        },
--        setup = {
--          jdtls = function()
--            require('java').setup {
--              -- Your custom nvim-java configuration goes here
--            }
--          end,
--        },
--      },
--    },
--  },
--}

-- return {
--   'nvim-java/nvim-java',
--   lazy = false, -- 🔴 important
--   dependencies = {
--     'neovim/nvim-lspconfig',
--     'mfussenegger/nvim-dap',
--     'williamboman/mason.nvim',
--   },
--   config = function()
--     require('java').setup()
--   end,
-- }
return {
  'nvim-java/nvim-java',
  lazy = false,
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'williamboman/mason.nvim',
  },
  config = function()
    require('java').setup()

    -- IMPORTANT: force jdtls to attach with correct root
    local lspconfig = require 'lspconfig'
    lspconfig.jdtls.setup {
      root_dir = lspconfig.util.root_pattern('settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts', '.git'),
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = 'interactive',
          },
          import = {
            gradle = {
              enabled = true,
            },
          },
        },
      },
    }
  end,
}
