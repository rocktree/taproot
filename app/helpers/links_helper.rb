module LinksHelper

  def icon_to(icon, path, options = {})
    link_to(path, options) { content_tag(:i, nil, :class => "icon-#{icon}") }
  end

end
