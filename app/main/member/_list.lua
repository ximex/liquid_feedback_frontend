local members_selector = param.get("members_selector", "table")
local initiative = param.get("initiative", "table")
local issue = param.get("issue", "table")
local trustee = param.get("trustee", "table")
local initiator = param.get("initiator", "table")
local for_votes = param.get("for_votes", atom.boolean)

if initiative or issue then
  if for_votes then
    members_selector:left_join("delegating_voter", "_member_list__delegating_voter", { "_member_list__delegating_voter.issue_id = issue.id AND _member_list__delegating_voter.member_id = ?", app.session.member_id })
    members_selector:add_field("_member_list__delegating_voter.delegate_member_ids", "delegate_member_ids")
  else
    members_selector:left_join("delegating_interest_snapshot", "_member_list__delegating_interest", { "_member_list__delegating_interest.event = issue.latest_snapshot_event AND _member_list__delegating_interest.issue_id = issue.id AND _member_list__delegating_interest.member_id = ?", app.session.member_id })
    members_selector:add_field("_member_list__delegating_interest.delegate_member_ids", "delegate_member_ids")
  end
end

ui.add_partial_param_names{ "member_list" }

local filter = {
  label = _"Order by",
  name = "member_list",
  {
    name = "name",
    label = _"A-Z",
    selector_modifier = function(selector) selector:add_order_by("name") end
  },
  {
    name = "name_desc",
    label = _"Z-A",
    selector_modifier = function(selector) selector:add_order_by("name DESC") end
  },
  {
    name = "newest",
    label = _"Newest",
    selector_modifier = function(selector) selector:add_order_by("created DESC, id DESC") end
  },
  {
    name = "oldest",
    label = _"Oldest",
    selector_modifier = function(selector) selector:add_order_by("created, id") end
  },
}

if initiative then
  filter[#filter] = {
    name = "delegations",
    label = _"Delegations",
    selector_modifier = function(selector) selector:add_order_by("weight DESC") end
  }
end

ui.filters{
  label = _"Change order",
  selector = members_selector,
  filter,
  content = function()
    ui.paginate{
      selector = members_selector,
      per_page = 100,
      content = function() 
        ui.container{
          attr = { class = "member_list" },
          content = function()
            local members = members_selector:exec()

            for i, member in ipairs(members) do
              execute.view{
                module = "member",
                view = "_show_thumb",
                params = {
                  member = member,
                  initiative = initiative,
                  issue = issue,
                  trustee = trustee,
                  initiator = initiator
                }
              }
            end


          end
        }
        slot.put('<br style="clear: left;" />')
      end
    }
  end
}
