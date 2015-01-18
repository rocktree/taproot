module NavHelper

  def read_nav_config(config)
    file = "#{Rails.root}/config/taproot/#{config}.yml"
    return nil unless File.exists?(file)
    nav = {}
    YAML.load_file(file).each { |k,v| nav[k] = v.to_ostruct }
    nav
  end

  def builder_site_nav_config
    read_nav_config('builder_site_nav')
  end

  def builder_site_nav
    content_tag(:ul) do
      items = ''
      builder_site_nav_config.each do |item, attrs|
        path = send(attrs.path, current_site)
        items += content_tag(
          :li,
          :class => builder_nav_active?(item, path, attrs.controllers) ? 'active' : nil
        ) { link_to(attrs.label, path) }
      end
      items.html_safe
    end
  end

  def builder_nav_active?(item, path, controllers = [])
    if controllers.include?(controller_name) || request.path == path
      @builder_nav_active_item = item
      true
    else
      false
    end
  end

  def sidebar(partial = 'sidebar')
    content_tag(:aside, :id => 'page-sidebar') { render(:partial => partial) }
  end

end
