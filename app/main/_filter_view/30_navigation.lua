slot.put_into("app_name", config.app_title)

slot.select('navigation', function()

  ui.link{
    content = function()
      ui.tag{ attr = { class = "logo_liquid" }, content = "Liquid" }
      ui.tag{ attr = { class = "logo_feedback" }, content = "Feedback" }
      slot.put(" &middot; ")
      ui.tag{ content = config.instance_name }
    end,
    module = 'index',
    view   = 'index'
  }
        ui.link{
        content = _"Search",
        module = 'index',
        view   = 'search'
      }


  
  if config.public_access and app.session.member == nil then
    ui.link{
      text   = _"Login",
      module = 'index',
      view   = 'login',
      params = {
        redirect_module = request.get_module(),
        redirect_view = request.get_view(),
        redirect_id = param.get_id()
      }
    }
  end

  if app.session.member == nil then
    ui.link{
      text   = _"Registration",
      module = 'index',
      view   = 'register'
    }
    ui.link{
      text   = _"Reset password",
      module = 'index',
      view   = 'reset_password'
    }
  end
end)


slot.select('navigation_right', function()
  ui.tag{ 
    tag = "ul",
    attr = { id = "member_menu" },
    content = function()
      ui.tag{ 
        tag = "li",
        content = function()
          ui.link{
            module = "index",
            view = "menu",
            content = function()
              if app.session.member_id then
                execute.view{
                  module = "member_image",
                  view = "_show",
                  params = {
                    member = app.session.member,
                    image_type = "avatar",
                    show_dummy = true,
                    class = "micro_avatar",
                  }
                }
                ui.tag{ content = app.session.member.name }
              else
                ui.tag{ content = _"Select language" }
              end
            end
          }
          execute.view{ module = "index", view = "_menu" }
        end
      }
    end
  }
end)

slot.select("footer", function()
  if app.session.member_id and app.session.member.admin then
    ui.link{
      text   = _"Admin",
      module = 'admin',
      view   = 'index'
    }
    slot.put(" &middot; ")
  end
  ui.link{
    text   = _"About site",
    module = 'index',
    view   = 'about'
  }
  slot.put(" &middot; ")
  ui.link{
    text   = _"Use terms",
    module = 'index',
    view   = 'usage_terms'
  }
  slot.put(" &middot; ")
  ui.tag{ content = _"This site is using" }
  slot.put(" ")
  ui.link{
    text   = _"LiquidFeedback",
    external = "http://www.public-software-group.org/liquid_feedback"
  }
end)


if config.app_logo then
  slot.select("logo", function()
    ui.image{ static = config.app_logo }
  end)
end

execute.inner()
