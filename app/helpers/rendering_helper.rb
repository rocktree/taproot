module RenderingHelper

  def builder_page_title(title, &block)
    content_tag(:section, :class => 'page-title') do
      o = content_tag(:h1, title)
      o += capture(&block) if block_given?
      o.html_safe
    end
  end

  def subtitle(subtitle)
    content_tag(:p, subtitle, :class => 'subtitle')
  end

  def data_table(collection, partial = nil)
    content_tag(:section, :class => 'data-table') do
      if partial.nil?
        render(collection)
      else
        render(:partial => partial, :collection => collection)
      end
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

  def form_tabs(tabs)
    content_tag(:ul, :class => 'tabs') do
      o = ''
      tabs.each do |t| 
        label = t.gsub(/\-/, ' ').titleize
        o += content_tag(:li, link_to(label, '#', :data => { 
          :section => t.downcase } ))
      end
      o.html_safe
    end
  end

  def em_p(text)
    content_tag(:p, :class => 'note') { content_tag(:em) { text } }
  end

end
