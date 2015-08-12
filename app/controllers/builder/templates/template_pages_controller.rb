class Builder::Templates::TemplatePagesController < Editor::BaseController

  def index
    @pages = current_template_pages
    if params[:published]
      if ['published','draft'].include?(params[:published])
        @pages = @pages.select { |p| p.send("#{params[:published]}?") }
      end
    else
      redirect_to builder_site_template_pages_path(
        current_site,
        current_template,
        :published => 'all'
      )
    end
    @paginated_pages = Kaminari.paginate_array(@pages).page(params[:page]).per(10)
  end

  private

    def builder_html_title
      @builder_html_title ||= "Pages >> #{current_template.title}"
    end

end
