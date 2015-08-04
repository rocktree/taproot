class Builder::TemplatesController < Editor::BaseController

  before_filter :verify_current_template, :except => [:index, :new, :create]
  before_filter :verify_admin

  def index
    @templates = site_templates
    if params[:tmpl_status] && params[:tmpl_status] != 'all'
      @templates = @templates.select { |t| t.send("#{params[:tmpl_status]}?") }
    elsif params[:tmpl_status] != 'all'
      redirect_to(
        builder_site_templates_path(current_site, :tmpl_status => 'all')
      )
    end
  end

  def show
  end

  def new
    @current_template = Template.new
  end

  def create
    if params[:template][:existing_template].blank?
      @current_template = Template.new(create_params)
    else
      existing_template = site_templates.select { |t|
        t.id == params[:template][:existing_template].to_i }.first
      if existing_template.blank?
        fail "Could not find template."
      end
      @current_template = existing_template.dup
      @current_template.title = params[:template][:title]
      @current_template.slug = nil
      current_template.save!
      current_template.template_groups.each(&:destroy)
      existing_template.template_groups.each do |group|
        new_group = group.dup
        new_group.template = current_template
        new_group.save!
        group.template_fields.each do |field|
          new_field = field.dup
          new_field.template_group = new_group
          new_field.save!
        end
      end
    end
    if current_template.save
      redirect_to(
        builder_route([current_template], :edit),
        :notice => 'Template created! Now, add your developer settings.'
      )
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    slug = current_template.slug
    if current_template.update(update_params)
      route = redirect_route.gsub(/\/#{slug}\//, "/#{current_template.slug}/")
      redirect_to(route, :notice => 'Template saved!')
    else
      render 'edit'
    end
  end

  def destroy
    if current_template.deletable?
      current_template.destroy
      redirect_to builder_route([site_templates], :index),
        :notice => 'Template deleted successfully!'
    else
      redirect_to builder_route([site_templates], :index),
        :alert => 'You are not allowed to delete a template with pages.'
    end
  end

  private

    def create_params
      params.require(:template).permit(:title, :description)
        .merge(:site => current_site, :last_editor => current_user)
    end

    def update_params
      params.require(:template).permit(
        :title,
        :description,
        :slug,
        :can_be_root,
        :order_method,
        :order_direction,
        :limit_pages,
        :max_pages,
        :has_show_view,
        :can_have_documents,
        :child_ids => [],
        :resource_type_ids => []
      ).merge(:last_editor => current_user)
    end

    def redirect_route
      params[:template][:redirect_route]
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'edit', 'update'
          "Edit >> #{current_template.title}"
        when 'show'
          "Help >> #{current_template.title}"
        when 'index'
          "#{current_site.title} Templates"
        when 'new', 'create'
          "New Template"
        end
      end
    end

end
