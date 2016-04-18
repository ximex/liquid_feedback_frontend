local return_to = param.get("return_to")
local return_to_area_id param.get("return_to_area_id", atom.integer)

ui.titleMember(_"notification settings")

execute.view {
  module = "member", view = "_sidebar_whatcanido", params = {
    member = app.session.member
  }
}

ui.form{
  attr = { class = "vertical" },
  module = "member",
  action = "update_notify_level",
  routing = {
    ok = {
      mode = "redirect",
      module = return_to == "area" and "area" or return_to == "home" and "index" or "member",
      view = return_to == "area" and "show" or return_to == "home" and "index" or "show",
      id = return_to == "area" and return_to_area_id or return_to ~= "home" and app.session.member_id or nil
    }
  },
  content = function()

    ui.section( function()

      ui.sectionHead( function()
        ui.heading { level = 1, content = _"Do you like to receive updates by email?" }
      end )

    
      ui.sectionRow( function()
      
        ui.container{ content = function()
          ui.tag{
            tag = "input", 
            attr = {
              id = "notify_level_all",
              type = "radio", name = "disable_notifications", value = "false",
              checked = not app.session.member.disable_notifications and "checked" or nil
            }
          }
          ui.tag{
            tag = "label", attr = { ['for'] = "notify_level_all" },
            content = _"I like to receive notifications"
          }
        end }
        
        slot.put("<br />")
        
        ui.container{ attr = { style = "margin-left: 3em;" }, content = function()
        
          ui.container{ content = _"You will receive status update notification on issue phase changes. Additionally you can subscribe for a regular digest including updates on initiative drafts and new suggestions." }
          
          ui.container{ content = function()
            ui.tag{
              tag = "input", 
              attr = {
                id = "digest_on",
                type = "radio", name = "digest", value = "true",
                checked = app.session.member.notification_hour ~= nil and "checked" or nil
              }
            }
            ui.tag{
              tag = "label", attr = { ['for'] = "digest_on" },
              content = _"I want to receive a regular digest. Send the digest at:"
            }
          end }
            
          ui.container{ attr = { style = "margin-left: 4em;" }, content = function()
            ui.tag{ content = _"Day:" }
            slot.put(" ")
            ui.field.select{
              container_attr = { style = "display: inline-block; vertical-align: middle;" },
              attr = { style = "width: 10em;" },
              name = "notification_dow",
              foreign_records = {
                { id = "daily", name = _"daily" },
                { id = 0, name = _"Sunday" },
                { id = 1, name = _"Monday" },
                { id = 2, name = _"Tuesday" },
                { id = 3, name = _"Wednesday" },
                { id = 4, name = _"Thursday" },
                { id = 5, name = _"Friday" },
                { id = 6, name = _"Saturday" }
              },
              foreign_id = "id",
              foreign_name = "name",
              value = app.session.member.notification_dow
            }
            
            slot.put(" ")

            ui.tag{ content = _"Hour:" }
            slot.put(" ")
            local foreign_records = {}
            for i = 0, 23 do
              foreign_records[#foreign_records+1] = {
                id = i,
                name = string.format("%02d:00 - %02d:59", i, i),
              }
            end
            ui.field.select{
              container_attr = { style = "display: inline-block; vertical-align: middle;" },
              attr = { style = "width: 6em;" },
              name = "notification_hour",
              foreign_records = foreign_records,
              foreign_id = "id",
              foreign_name = "name",
              value = app.session.member.notification_hour
            }
          end }
          
          ui.container{ content = function()
            ui.tag{
              tag = "input", 
              attr = {
                id = "digest_off",
                type = "radio", name = "digest", value = "false",
                checked = app.session.member.notification_dow == nil and app.session.member.notification_hour == nil and "checked" or nil
              }
            }
            ui.tag{
              tag = "label", attr = { ['for'] = "digest_off" },
              content = _"Don't send me digest"
            }
          end }
        end }
        
        slot.put("<br />")
        
        ui.container{ content = function()
          ui.tag{
            tag = "input", 
            attr = {
              id = "notify_level_none",
              type = "radio", name = "disable_notifications", value = "true",
              checked = app.session.member.disable_notifications and "checked" or nil
            }
          }
          ui.tag{
            tag = "label", attr = { ['for'] = "notify_level_none" },
            content = _"Don't send me notification by email"
          }
        end }
        
        slot.put("<br />")
      
        ui.tag{
          tag = "input",
          attr = {
            type = "submit",
            class = "btn btn-default",
            value = _"Save"
          },
          content = ""
        }
        slot.put("<br /><br /><br />")
        
        slot.put(" ")
        if return_to == "home" then
          ui.link {
            module = "index", view = "index",
            content = _"cancel"
          }
        else
          ui.link {
            module = "member", view = "show", id = app.session.member_id, 
            content = _"cancel"
          }
        end
      end ) 
    end )
    
  end
}
 
