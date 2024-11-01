return {
  'jedrzejboczar/nvim-dap-cortex-debug',
  dependencies = { 'mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui', 'nvim-neotest/nvim-nio' },
  lazy = true,
  opts = {
    dapui_rtt = false,
  },
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
    { '<f5>', function() require('dap').continue() end, desc = 'Launch/continue debug session' },
    { '<f11>', function() require('dap').step_over() end, desc = 'Step over' },
    { '<f10>', function() require('dap').step_into() end, desc = 'Step into' },
    { '<leader>di', function() require('dap').repl.open() end, desc = 'Inspect the state' },
  },
  config = function(_, opts)
    local cortex_debug, dap, dapui = require('dap-cortex-debug'), require('dap'), require('dapui')
    cortex_debug.setup(opts)
    dapui.setup()

    local input = vim.fn.input
    dap.configurations.c = {
      cortex_debug.jlink_config{
        name = 'Attach to JLinkGDBServerCLExe',
        interface = 'swd',
        request = 'launch',
        toolchainPath = '/opt/gcc-arm-none-eabi/bin',
        executable = function()
          vim.api.nvim_exec2([[
            function! ListElfFiles(A,L,P)
              return split(system('find ' . getcwd() . ' -iname "*.elf" 2>/dev/null'), '\n')
            endfunction
          ]], {})
          return input('Path to executable: ', vim.fn.getcwd(), 'customlist,ListElfFiles')
        end,
        device = function()
          return input('-device ', 'Cortex-M33')
        end,
        serverArgs = function()
          vim.api.nvim_exec2([[
            function! ListSeggers(A,L,P)
              return system('nrfjprog -i')
            endfunction
          ]], {})
          return {
            '-select', 'USB=' .. input('-select USB=', '', 'custom,ListSeggers'),
          }
        end,
        rttConfig = { enabled = false },
      }
    }
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end
}
