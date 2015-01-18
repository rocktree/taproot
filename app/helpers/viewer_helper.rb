module ViewerHelper

  def viewer_service
    @viewer_service ||= "#{current_site.title.gsub(/\ /, '')}Viewer".constantize.new(current_site)
  end

  def meta_tag(content)
    content_tag(
      :meta, 
      nil, 
      :name => 'description', 
      :content => content
    ) unless content.blank?
  end

  def viewer_partial(name)
    render :partial => "viewer/#{current_site.slug}/#{name}"
  end

  def viewer_collection(collection, partial)
    render(
      :partial => "viewer/#{current_site.slug}/#{partial}", 
      :collection => collection
    )
  end

  def viewer_main_nav(options = {})
    content_tag(:nav, :class => options[:nav_class]) do
      content_tag(:ul, :class => options[:ul_class]) do
        o = ''
        site_nav_pages.each do |page|
          path = is_home_page?(page) ? viewer_home : viewer_page(page.slug)
          active = (request.path.split('/').last == path.split('/').last)
          o += content_tag(
            :li, 
            link_to(
              page.slug.gsub(/\_/, ' ').titleize, 
              path,
              :class => "#{page.slug} #{'active' if active}"
            ),
            :class => page.slug
          )
        end
        o.html_safe
      end
    end
  end

  def viewer_page_title(title, options = {})
    content_tag(:header, options[:header]) do
      content_tag(:h1) do
        content_tag(:span, title)
      end
    end
  end

  def viewer_image_path(filename)
    image_path "viewer/#{current_site.slug}/#{filename}"
  end

  def viewer_image(filename, options = {})
    image_tag "viewer/#{current_site.slug}/#{filename}", options
  end

  def main_header_image
    viewer_image('header.jpg')
  end

  def viewer_logo_image
    viewer_image('logo.png')
  end

  def slug_title(slug)
    slug.gsub(/\_/, ' ').humanize.titleize
  end

  def site_settings
    @site_settings ||= current_site.settings
  end

end
