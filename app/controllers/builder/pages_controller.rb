class Builder::PagesController < BuilderController

  def index
    if site_root_pages.size > 0
      redirect_to(builder_route([site_root_pages.first], :show))
    else
      redirect_to(builder_route([site_root_pages], :new))
    end
  end

  def show
    current_page
    if template_children.size == 0 || current_page.children.size == 0
      redirect_to builder_route([current_page], :edit)
    end
  end

  def new
    redirect_to current_site unless params[:template]
    @current_template = current_site.templates.find_by_slug(params[:template])
    @current_page = Page.new
  end

  def create
    process_files
    @current_page = Page.new(create_params)
    if current_page.save!
      # save_files
      redirect_to(
        builder_route([current_page], :edit), 
        :notice => t(
          'notices.created', 
          :item => controller_name.humanize.titleize
        )
      )
    else
      render('new')
    end
  end

  def update
    process_files
    if current_page.update(update_params)
      # save_files
      redirect_to(builder_route([current_page], :edit),
        :notice => t(
          'notices.updated', 
          :item => controller_name.humanize.titleize
        )
      )
    else
      render('edit')
    end
  end

  def destroy
    parent_page = current_page.parent
    current_page.destroy
    if parent_page.nil?
      path = builder_route([site_root_pages], :index)
    else
      path = builder_route([parent_page], :show)
    end
    redirect_to(
      path, 
      :notice => t('notices.updated', :item => 'Page')
    )
  end

  private

    def create_params
      @current_template = current_site.templates.find_by_id(
        params[:page][:template_id]
      )
      fields = []
      template_groups.each { |g| fields << g.fields }
      fields = fields.flatten.uniq.collect(&:slug).map { |f| f.to_sym }
      params.require(:page).permit(
        :title,
        :slug,  
        :description, 
        :body, 
        :body_md,
        :published,
        :position,
        :template,
        :parent_id,
        :show_in_nav,
        :field_data => fields
      ).merge(
        :template => current_template,
      )
    end

    def update_params
      fields = []
      template_groups.each { |g| fields << g.fields }
      fields = fields.flatten.uniq.collect(&:slug).map { |f| f.to_sym }
      params.require(:page).permit(
        :title,
        :slug,  
        :description, 
        :body, 
        :body_md,
        :published,
        :position,
        :parent_id,
        :show_in_nav,
        :template,
        :field_data => fields
      )
    end

    def process_files
      @files_to_save = {}
      unless params[:page][:field_data].nil?
        keys = params[:page][:field_data].keys
        keys.each do |key|
          value = nil
          if key.starts_with?('rtfile_')
            clean_key = key.gsub(/rtfile\_/, '')
            value = params[:page][:field_data][key.to_sym]
            params[:page][:field_data][clean_key.to_sym] = value
            @files_to_save[clean_key] = value.to_i
          end
        end
      end
    end

end
