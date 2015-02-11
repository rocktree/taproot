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

  def current_template_fields
    @current_template_fields ||= begin
      current_template.template_fields
    end
  end  

  def site_has_templates?
    site_templates.size > 0
  end

  def template_children
    @template_children ||= begin
      children = current_template.children.reject(&:blank?)
      current_site.templates.where(:slug => children)
    end
  end

  def page_type_field_options
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
    current_page_type.fields.each { |f| fields << [f.title, f.slug] }
    ([
      ['Title','title'],
      ['URL','slug'],
      ['Position','position'],
      ['Created','created_at'],
      ['Updated','updated_at'],
    ] + fields).uniq.sort
  end

  def current_template_tabs
    t = current_template
    f = current_template_fields
    list_tabs([
      {
        :title => 'Details', 
        :path => builder_route([t], :edit)
      },
      {
        :title => 'Fields', 
        :path => builder_route([t, f], :index), 
        :controllers => ['fields']
      }
    ])
  end

end
