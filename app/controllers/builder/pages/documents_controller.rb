class Builder::Pages::DocumentsController < Editor::PagesController

  before_filter :verify_has_docs

  def index
  end

  def create
    if request.xhr? && params[:file]
      doc = current_site.documents.find_by_idx(params[:file])
      unless doc.nil?
        PageDocument.create!(
          :page => current_page,
          :document => doc
        )
        render :nothing => true
      end
    end
  end

  def destroy
    doc = current_site.documents.find_by_idx(params[:idx])
    unless doc.nil?
      association = PageDocument.where(
        :page => current_page, :document => doc
      ).first
      association.destroy unless association.nil?
    end
    redirect_to(
      builder_site_page_documents_path(current_site, current_page)
    )
  end

  private

    def verify_has_docs
      not_found unless current_template.can_have_documents?
    end

end
