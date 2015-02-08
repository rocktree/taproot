module TemplatesHelper

  def site_templates
    @site_templates ||= current_site.templates.alpha
  end

  def current_template
    @current_template ||= begin
      if current_page.nil?
        p = params[:template_slug] || params[:slug]
        current_site.templates.find_by_slug(p)
      else
        current_page.template
      end
    end
  end

  def current_template_groups
    @current_template_groups ||= begin
      current_template.groups.in_order.includes(:template_fields)
    end
  end

  def current_template_group
    @current_template_group ||= begin
      current_template_groups.select { |g| g.slug == params[:slug] }.first
    end
  end

  def current_template_fields
    @current_template_fields ||= begin
      current_template.fields
    end
  end  

  def current_template_field
    @current_template_field ||= begin
      current_template_fields.select { |f| f.slug == params[:slug] }.first
    end
  end

  def site_has_templates?
    site_templates.size > 0
  end

  def template_children
    @template_children ||= begin
      children = current_template.children.reject(&:blank?)
      site_templates.select { |t| children.include?(t.slug) }
    end
  end

  def template_field_options
    [
      ['String', 'string'],
      ['Text', 'text'],
      ['Dropdown', 'select'],
      ['Date', 'date'],
      ['Checkbox', 'boolean'],
      ['Checkboxes', 'check_boxes'],
      ['Radio Buttons', 'radio_buttons'],
      # ['Date & Time', 'datetime'],
      ['File', 'file']
      # ['Image', 'image'],
    ]
  end

  def order_by_fields
    fields = []
    current_template.fields.each { |f| fields << [f.title, f.slug] }
    ([
      ['Title','title'],
      ['URL','slug'],
      ['Position','position'],
      ['Created','created_at'],
      ['Updated','updated_at'],
    ] + fields).uniq.sort
  end

  def current_template_actions
    s = current_site
    t = current_template
    [
      {
        :title => 'Display Settings', 
        :path => builder_site_template_settings_path(s, t)
      },
      {
        :title => 'Developer Settings', 
        :path => builder_site_template_dev_settings_path(s, t)
      },
      {
        :title => 'Form Fields', 
        :path => builder_route([t, t.fields], :index), 
        :controllers => ['fields', 'groups']
      },
      {
        :title => 'Developer Help', 
        :path => '#', #builder_route([t, f], :index), 
        # :controllers => ['fields']
      }
    ]
  end

  def current_template_breadcrumbs
    content_tag(:nav, :class => 'breadcrumbs') do
      content_tag(:ul) do
        o = content_tag(
          :li, 
          link_to('All Templates', builder_route([site_templates], :index))
        )
        if current_template
          o += content_tag(
            :li, 
            link_to(
              current_template.title, 
              builder_route([current_template], :show)
            )
          )
          if ['fields','groups'].include?(controller_name)
            o += content_tag(
              :li, 
              link_to(
                'Form Fields', 
                builder_route(
                  [current_template, current_template_fields], 
                  :index
                )
              )
            )
            o += content_tag(
              :li, 
              link_to(
                "#{action_name.titleize} #{controller_name.singularize.titleize}", 
                request.path
              )
            ) unless action_name == 'index'
          else
            o += content_tag(
              :li, 
              link_to(request.path.split('/').last.titleize, request.path)
            ) unless action_name == 'index'
          end
          o.html_safe
        end
      end
    end
  end

end
