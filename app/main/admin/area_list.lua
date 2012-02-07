local unit_id = param.get("unit_id", atom.integer)
local unit = Unit:by_id(unit_id)

local show_not_in_use = param.get("show_not_in_use", atom.boolean) or false

local areas = Area:build_selector{ unit_id = unit_id, active = not show_not_in_use }:exec()


slot.put_into("title", _("Area list of '#{unit_name}'", { unit_name = unit.name}))


slot.select("actions", function()

  ui.link{
    attr = { class = { "admin_only" } },
    text = _"Back to unit list",
    module = "admin",
    view = "unit_list"
  }

  if show_not_in_use then
    ui.link{
      attr = { class = { "admin_only" } },
      text = _"Show areas in use",
      module = "admin",
      view = "area_list",
      params = { unit_id = unit_id }
    }

  else
    ui.link{
      attr = { class = { "admin_only" } },
      text = _"Create new area",
      module = "admin",
      view = "area_show",
      params = { unit_id = unit_id }
    }
    ui.link{
      attr = { class = { "admin_only" } },
      text = _"Show areas not in use",
      module = "admin",
      view = "area_list",
      params = { show_not_in_use = true, unit_id = unit_id }
    }
  end

end)


ui.list{
  records = areas,
  columns = {

    { label = _"Area", name = "name" },

    { content = function(record)
        if app.session.member.admin then
          ui.link{
            attr = { class = { "action admin_only" } },
            text = _"Edit",
            module = "admin",
            view = "area_show",
            id = record.id
          }
        end
      end
    }

  }
}