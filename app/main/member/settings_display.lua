ui.title(_"Display settings")

util.help("member.settings.display", _"Display settings")

ui.form{
  attr = { class = "vertical" },
  module = "member",
  action = "update_display",
  routing = {
    ok = {
      mode = "redirect",
      module = "index",
      view = "index"
    }
  },
  content = function()
    ui.field.select{
      label = _"Number of initiatives to preview",
      foreign_records = {
        { id =  3, name = "3" },
        { id =  4, name = "4" },
        { id =  5, name = "5" },
        { id =  6, name = "6" },
        { id =  7, name = "7" },
        { id =  8, name = "8" },
        { id =  9, name = "9" },
        { id = 10, name = "10" },
      },
      foreign_id = "id",
      foreign_name = "name",
      name = "initiatives_preview_limit",
      value = app.session.member:get_setting_value("initiatives_preview_limit")
    }
    ui.submit{ value = _"Change display settings" }
  end
}
