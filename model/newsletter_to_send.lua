NewsletterToSend = mondelefant.new_class()
NewsletterToSend.table = 'newsletter_to_send'

NewsletterToSend:add_reference{
  mode          = 'm1',
  to            = "Newsletter",
  this_key      = 'newsletter_id',
  that_key      = 'id',
  ref           = 'newsletter',
}

NewsletterToSend:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'recipient_id',
  that_key      = 'id',
  ref           = 'member',
}

function NewsletterToSend:get_next()
  return NewsletterToSend:new_selector()
    :set_distinct("newsletter_id")
    :add_order_by("newsletter_id")
    :limit(1)
    :optional_object_mode()
    :exec()
end

function NewsletterToSend:by_newsletter_id(id)
  return NewsletterToSend:new_selector()
    :add_where{ "newsletter_id = ?", id }
    :optional_object_mode()
    :exec()
end