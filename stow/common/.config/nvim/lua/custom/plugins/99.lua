-- For a doc on what functions exist and what they do, see /Users/dcapwell/src/github/99/summary.md
return {
  'ThePrimeagen/99',
  config = function()
    local _99 = require '99'

    -- Track current model locally since _99_state isn't exposed
    local current_model = 'genai-claude/aws:anthropic.claude-opus-4-5-20251101-v1:0'

    -- For logging that is to a file if you wish to trace through requests
    -- for reporting bugs, i would not rely on this, but instead the provided
    -- logging mechanisms within 99.  This is for more debugging purposes
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    _99.setup {
      model = current_model,
      logger = {
        level = _99.FATAL,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },

      --- A new feature that is centered around tags
      completion = {
        -- Location where your skills are stored
        custom_rules = {
          '~/.config/opencode/skills',
        },

        --- What autocomplete do you use.  We currently only
        --- support cmp right now
        source = 'cmp',
      },

      --- WARNING: if you change cwd then this is likely broken
      --- ill likely fix this in a later change
      ---
      --- md_files is a list of files to look for and auto add based on the location
      --- of the originating request.  That means if you are at /foo/bar/baz.lua
      --- the system will automagically look for:
      --- /foo/bar/AGENT.md
      --- /foo/AGENT.md
      --- assuming that /foo is project root (based on cwd)
      md_files = {
        'AGENT.md',
      },
    }

    -- AI fills in the function body and gives a prompt for more instructions
    vim.keymap.set('n', '<leader>9f', _99.fill_in_function_prompt, { desc = '99: Fill in function body; with a prompt' })
    vim.keymap.set('n', '<leader>9F', _99.fill_in_function, { desc = '99: Fill in function body' })

    -- AI replaces the visual selection and gives a prompt for more instructions
    vim.keymap.set('v', '<leader>9v', _99.visual_prompt, { desc = '99: Visual prompt; with a prompt' })
    vim.keymap.set('v', '<leader>9V', _99.visual, { desc = '99: Visual prompt' })

    --- if you have a request you dont want to make any changes, just cancel it
    vim.keymap.set({ 'n', 'v' }, '<leader>9s', _99.stop_all_requests, { desc = '99: Stop all requests' })

    -- Select model from opencode models with fuzzy finder
    vim.keymap.set('n', '<leader>9m', function()
      vim.fn.jobstart('opencode models', {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if not data then
            return
          end
          local models = { current_model }
          for _, line in ipairs(data) do
            if line and line ~= '' and line ~= current_model then
              table.insert(models, line)
            end
          end
          if #models == 0 then
            vim.notify('No models found', vim.log.levels.WARN)
            return
          end
          vim.schedule(function()
            vim.ui.select(models, {
              prompt = 'Select model:',
            }, function(choice)
              if choice then
                current_model = choice
                _99.set_model(choice)
                vim.notify('Model set to: ' .. choice, vim.log.levels.INFO)
              end
            end)
          end)
        end,
        on_stderr = function(_, data)
          if data and data[1] ~= '' then
            vim.schedule(function()
              vim.notify('Error fetching models: ' .. table.concat(data, '\n'), vim.log.levels.ERROR)
            end)
          end
        end,
      })
    end, { desc = '99: Select model' })
  end,
}
