module EmitEventSignatureHelper
  def event_signature(callee_object, link = true)
    if link
      "<strong>%s</strong>" % link_to_details_url(callee_object)
    else
      "<strong>%s</strong>" % h(callee_object["event_name"])
    end
  end

  def link_to_details_url(method_object)
    # Define the anchor to link method list items to corresponding event details
    url ||= "##{method_object.name}"
    event_name = method_object["event_name"]
    params = SymbolHash.new(false).update(
      :href => url,
      :title => h(url)
    )
    "<a #{tag_attrs(params)}>#{event_name}</a>".gsub(/[\r\n]/, ' ')
  end
end
