module RenderingHelper

  def current_view_title
    if current_site
      if current_site.id.present?
        link_to(current_site.title, builder_site_path(current_site))
      end
    else
      link_to('Dashboard', root_path)
    end
  end

  def builder_page_title(title, options = {}, &block)
    content_tag(:section, :class => "page-title #{options[:class]}") do
      o = content_tag(:h1, title)
      o += capture(&block) if block_given?
      o.html_safe
    end
  end

  def builder_page_header
    content_tag(:div, :class => 'current-page-header page-title') do
      o  = content_tag(:h1, :class => 'title') do
         o2  = current_page.title
         o2 += content_tag(:span, current_page.page_path)
         o2.html_safe
      end
      o += content_tag(:div, :class => 'attributes') do
        o2  = link_to(
          '#',
          :class => "status #{current_page.published? ? 'published' : 'draft'}"
        ) do
          o3  = content_tag(:span, 'Status:', :class => 'label')
          o3 += content_tag(:span, current_page.status.titleize)
        end
        o2 += link_to(
          builder_route([current_template], :edit),
          :class => 'template'
        ) do
          o3  = content_tag(:span, 'Template:', :class => 'label')
          o3 += content_tag(:span, current_template.title)
        end
        o2 += link_to('#', :class => 'menu disabled') do
          o3  = content_tag(:span, 'Menu:', :class => 'label')
          o3 += content_tag(:span, current_page.show_in_nav? ? 'Visible' : 'Hidden')
        end
      end
    end
  end

  def subtitle(subtitle)
    content_tag(:p, subtitle, :class => 'subtitle')
  end

  def data_table(collection, partial = nil, &block)
    content_tag(:section, :class => 'data-table') do
      o = ''
      if block_given?
        o += capture(&block)
      end
      if partial.nil?
        o += render(collection)
      else
        o += render(:partial => partial, :collection => collection)
      end
      o.html_safe
    end
  end

  def list_tabs(tabs)
    content_tag(:ul, :class => 'list-tabs') do
      o = ''
      tabs.each do |t|
        active = false
        if (t[:controllers] && t[:controllers].include?(controller_name)) ||
          request.path == t[:path]
            active = true
        end
        o += content_tag(:li,
          link_to(
            t[:title],
            t[:path],
            :class => active == true ? 'active' : nil
          )
        )
      end
      o.html_safe
    end
  end

  def em_p(text)
    content_tag(:p, :class => 'note') { content_tag(:em) { text } }
  end

  def missing_content(text)
    content_tag(:p, text, :class => 'missing-content')
  end

  def google_analytics(id)
    render(
      :partial => 'application/google_analytics',
      :locals => { :google_analytics_id => id }
    )
  end

end
