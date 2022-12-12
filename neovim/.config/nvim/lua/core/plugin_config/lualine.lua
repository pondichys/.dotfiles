require('lualine').setup {
  options = {
    theme = 'onenord',
    icons_enabled = true,
  },
  sections = {
    lualine_a = {
      {
        'filename',
        path = 1,
      }
    }
  }
}
