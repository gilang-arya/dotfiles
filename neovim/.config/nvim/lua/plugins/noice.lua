return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify", -- untuk tampilan notifikasi
  },
  config = function()
    require("noice").setup({
      lsp = {
        progress = { enabled = true },
        hover = { enabled = true },
        signature = { enabled = true },
        message = { enabled = true },
        documentation = {
          view = "hover",
        },
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      messages = {
        enabled = true,
        view = "notify",
      },
      popupmenu = {
        enabled = true,
      },
      notify = {
        enabled = true,
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      -- Optional: views untuk tampilan lebih presisi
      -- views = { ... },
      -- Optional: routes untuk filter pesan
      -- routes = { ... },
    })
  end,
}

