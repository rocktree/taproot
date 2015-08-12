class Builder::SitesController < Editor::BaseController

  before_filter :set_layout_options

  def index
    redirect_to builder_dashboard_path
  end

  def update
    if current_site.update(site_params)
      redirect_to(
        route([current_site], :edit, 'builder'),
        :notice => t('notices.updated', :item => "Site")
      )
    else
      render('edit')
    end
  end

  def destroy
    sapwood = SapwoodProject.new(current_site)
    sapwood.remove_files
    current_site.destroy
    redirect_to(builder_sites_path, :notice => 'Site deleted successfully.')
  end

  def pull
    if current_site
      UpdateProjectWorker.perform_async(current_site.id)
    end
    redirect_to(
      route([current_site], :edit, 'builder'),
      :notice => 'Working on the task behind the scenes.'
    )
  end

  def import
    sapwood = SapwoodProject.new(current_site)
    sapwood.import_site
    redirect_to(
      route([current_site], :edit, 'builder'),
      :notice => 'Repo imported successfully!'
    )
  end

  def backup
    SapwoodDatabase.new.backup
    redirect_to(
      route([current_site], :edit, 'builder'),
      :notice => 'Database backed up successfully!'
    )
  end

  def symlink
    SapwoodProject.new(current_site).update_symlinks
    redirect_to(
      route([current_site], :edit, 'builder'),
      :notice => 'Symlinked successfully!'
    )
  end

  private

    def site_params
      params.require(:site).permit(
        :title,
        :url,
        :secondary_urls,
        :description,
        :home_page_id,
        :git_url,
        :image_croppings_attributes => [
          :id,
          :title,
          :ratio,
          :width,
          :height
        ]
      )
    end

    def set_layout_options
      if ['index', 'new', 'create'].include?(action_name)
        @options['sidebar'] = false
        @options['body_classes'] += ' my-sites'
      end
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'index'
          "My Sites"
        when 'edit', 'update'
          "Settings >> #{current_site.title}"
        end
      end
    end

end
