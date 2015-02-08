class Builder::PagesController < BuilderController

  def index
  end

  def show
    # current_page
    # if template_children.size == 0 || current_page.children.size == 0
    #   redirect_to builder_site_page_settings_path(
    #     current_site, current_page, current_template_groups.first
    #   )
    # else
    #   redirect_to builder_site_page_children_path(
    #     current_site, current_page, template_children.first
    #   )
    # end
  end

  def children
  end

  def new
    redirect_to current_site unless params[:template]
    @current_template = site_templates.find_by_slug(params[:template])
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

  def edit
    if current_template_group.nil?
      redirect_to builder_site_page_settings_path(
        current_site, current_page, current_template_groups.first
      )
    end
  end

  def update
    process_files
    if current_page.update(update_params)
      # save_files
      redirect_to(redirect_route,
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
      params.require(:page).permit(:title,:description)
        .merge(:template => current_template)
    end

    def update_params
      p = params.require(:page).permit(
        :title,
        :slug,  
        :description, 
        :body, 
        :body_md,
        :published,
        :position,
        :parent_id,
        :show_in_nav,
        :template
      )
      unless params[:page][:field_data].blank?
        p = p.merge(
          :field_data => current_page.field_data.merge(params[:page][:field_data])
        )
      end
      p
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

    def redirect_route
      params[:page][:redirect_route]
    end

end
