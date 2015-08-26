module Application
  module NavHelper

    def pages_subnav
      content_tag(:ul, :class => 'pages') do
        o = ''
        all_pages_tree.each do |node|
          page = page_from_tree_node(node)
          next if page.nil?
          o += content_tag(:li) do
            o2 = ''
            if node['children'].size > 0
              o2 += icon_to 'right', '#', :class => 'pages-inlist-trigger'
            end
            o2 += link_to(
              page.title,
              site_editor_page_path(current_site, page),
              :class => "droppable #{('active' if params[:slug] == page.slug)}",
              :data => { :page_id => page.id }
            )
            if node['children'].size > 0
              o2 += pages_subnav_loop(node['children'])
            end
            o2.html_safe
          end
        end
        o.html_safe
      end
    end

    def pages_subnav_loop(node)
      content_tag(:ul) do
        o = ''
        node.each do |child_node|
          page = page_from_tree_node(child_node)
          next if page.nil?
          o += content_tag(:li, :class => 'droppable',
                           :data => { :page_id => page.id } ) do
            o2 = ''
            if child_node['children'].size > 0
              o2 += icon_to 'right', '#', :class => 'pages-inlist-trigger'
            end
            o2 += link_to(
              page.title,
              site_editor_page_path(current_site, page),
              :class => "droppable #{('active' if params[:slug] == page.slug)}",
              :data => { :page_id => page.id }
            )
            if child_node['children'].size > 0
              o2 += pages_subnav_loop(child_node['children'])
            end
            o2.html_safe
          end
        end
        o.html_safe
      end
    end

    # # ------------------------------------------ Current Nav (left sidebar)

    # def current_nav(&block)
    #   content_tag(:aside, capture(&block), :id => 'current-nav')
    # end

    # def current_nav_section(title, &block)
    #   content_tag(:div, :class => 'nav-section') do
    #     o  = content_tag(:h3, title, :class => 'title')
    #     o += content_tag(:ul, capture(&block))
    #   end
    # end

    # # ------------------------------------------ Drilldown Nav (right sidebar)

    # def drilldown_nav(options = {}, &block)
    #   content_tag(:aside, :id => 'drilldown-nav', :class => 'sidebar') do
    #     content_tag(:nav, options[:nav_html]) do
    #       content_tag(:ul) { capture(&block) }
    #     end
    #   end
    # end

    # def drilldown_nav_new(label, path, klass = nil)
    #   content_tag(
    #     :li,
    #     link_to(label, path, :class => "new #{klass}"),
    #     :class => 'new-button'
    #   )
    # end

    # def drilldown_nav_back(label, path)
    #   link_to(label, path, :class => 'back-button')
    # end

    # def pages_drilldown_back_link
    #   if current_page_parent
    #     drilldown_nav_back(
    #       current_page_parent.title,
    #       builder_route([current_page_parent], :edit)
    #     )
    #   elsif current_page != home_page
    #     drilldown_nav_back(
    #       home_page.title,
    #       builder_route([home_page], :edit)
    #     )
    #   else
    #     drilldown_nav_back(
    #       'Site Dashboard',
    #       builder_site_path(current_site)
    #     )
    #   end
    # end

    # # ------------------------------------------ Old Helpers

    # def read_nav_config(config)
    #   file = "#{Rails.root}/config/sapwood/#{config}.yml"
    #   return nil unless File.exists?(file)
    #   nav = {}
    #   YAML.load_file(file).each { |k,v| nav[k] = v.to_ostruct }
    #   nav
    # end

    # # def builder_site_nav
    # #   content_tag(:ul, :class => current_user.admin? ? 'admin' : nil) do
    # #     items = ''
    # #     builder_site_nav_config.each do |item, attrs|
    # #       unless attrs.admin.present? && attrs.admin.to_bool == true &&
    # #         current_user.site_user?
    # #         path = send(attrs.path, current_site)
    # #         items += content_tag(
    # #           :li,
    # #           :class => builder_nav_active?(item, path, attrs.controllers) ? 'active' : nil
    # #         ) { link_to(attrs.label, path) }
    # #       end
    # #     end
    # #     items.html_safe
    # #   end
    # # end

    # # def builder_nav_active?(item, path, controllers = [])
    # #   if(
    # #     request.path =~ /^#{path}/ && (
    # #       controllers.include?(controller_name) || request.path == path
    # #     )
    # #   )
    # #     @builder_nav_active_item = item
    # #     true
    # #   else
    # #     false
    # #   end
    # # end

    # def sidebar(partial = 'sidebar')
    #   content_tag(:aside, :id => 'page-sidebar') { render(:partial => partial) }
    # end

    # def sidebar_item_active?(item)
    #   (item[:controllers] && item[:controllers].include?(controller_name)) ||
    #     request.path == item[:path]
    # end

    # def tab_active?(item)
    #   sidebar_item_active?(item)
    # end

  end
end
