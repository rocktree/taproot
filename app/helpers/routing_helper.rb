module RoutingHelper

  def route(items, action, namespace = '')
    if namespace.blank?
      i = ""
      s = ""
    else
      i = "#{namespace}_"
      s = "#{namespace}_"
    end
    pop = false
    if items.last.is_a?(Array)
      items[-1] = items.last.flatten.first
      pop = true
    end
    items.each do |item|
      klass = item.class.method_defined?(:model) ? item.model : item.class
      t = klass.table_name
      ts = t.singularize; s += "#{ts}_"
      item == items.last ? i += "#{t}_" : i += "#{ts}_"
    end
    objs = objs = items.reverse.drop(1).reverse
    case action
    when :index
      objs.empty? ? send("#{i}path") : send("#{i}path", *objs)
    when :new
      objs.empty? ? send("new_#{s}path") : send("new_#{s}path", *objs)
    when :edit
      send("edit_#{s}path", *items)
    when :show
      send("#{s}path", *items)
    end
  end

  def builder_route(items, action)
    route([current_site] + items, action, 'builder')
  end

  def viewer_home
    if ['localhost','cms.rocktree.us'].include?(request.host)
      viewer_home_path
    else
      send("#{current_site.slug.underscore}_home_path")
    end
  end

  def viewer_page(page_path)
    if request.host == TaprootSetting.site.url
      viewer_page_path(:page_path => page_path)
    else
      send("#{current_site.slug.underscore}_page_path", :page_path => page_path)
    end
  end

end
