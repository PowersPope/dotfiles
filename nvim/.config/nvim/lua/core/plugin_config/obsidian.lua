require("obsidian").setup({
  workspaces = {
    {
      name = "ObisidianNotes",
      path = "~/Documents/ObisidianNotes",
    },
  },

  daily_notes = {
    folder = "7. Journal/" .. os.date("%Y") .. "/" .. os.date("%m-%B") .. "/",
    date_format = "%Y-%m-%d-%A",
    default_tags = { "daily", "oregon" },
    template = "DailyNotesTemplate.md",
  },

  templates = {
    folder = "Templates",
  }

})
