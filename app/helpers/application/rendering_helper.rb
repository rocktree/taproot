module Application
  module RenderingHelper

    def partial(name, options = {})
      options = options.merge(:partial => name)
      render(options)
    end

    def icon_to(icon, path, options = {})
      link_to(path, options) { content_tag(:i, nil, :class => "icon-#{icon}") }
    end

  end
end
