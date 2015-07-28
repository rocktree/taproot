class Builder::DocumentsController < BuilderController

  include DocumentsHelper

  def index
    if request.xhr?
      render :partial => 'content', :layout => false
    end
  end

  def create
    respond_to do |format|
      format.json do
        @document = Document.create!(document_params)
        render :json => @document
      end
    end
  end

  def destroy
    current_document.destroy
    redirect_to builder_route([site_documents], :index),
      :notice => t('notices.deleted', :item => 'Image')
  end

  def max_file_size
    respond_to do |format|
      format.json { render :text => TopkitSetting.dragonfly.max_file_size }
    end
  end

  private

    def document_params
      params.require(:document).permit(:document).merge(:site => current_site)
    end

    def builder_html_title
      @builder_html_title ||= "Media >> #{current_site.title}"
    end

end
