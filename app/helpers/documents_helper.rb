module DocumentsHelper

  def site_documents
    @site_documents ||= current_site.documents.by_idx
  end

  def site_files
    site_documents
  end

  def paginated_site_files
    @paginated_site_files ||= begin
      Kaminari.paginate_array(site_files).page(params[:page] || 1).per(20)
    end
  end

  def current_page_documents
    @current_page_documents ||= begin
      if current_page
        current_page.documents
      else
        nil
      end
    end
  end

  def current_document
    @current_document ||= begin
      if controller_name == 'documents'
        current_site.documents.find_by_idx(params[:idx])
      elsif controller_name == 'croppings'
        current_site.documents.find_by_idx(params[:document_idx])
      end
    end
  end

  def current_file
    current_document
  end

  def current_image
    not_found unless current_file.is_image?
    current_file
  end

  def find_page_thumb(idx)
    file = current_site.documents.find_by_idx(idx)
    return file.thumbnail unless file.nil?
  end

  def cropped_image(image, version)
    unless image.nil?
      c = image.crop(version)
      if c.nil?
        c = current_site.image_croppings.find_by_slug(version)
        image_tag(image.document.thumb("#{c.width.to_i}x#{c.height.to_i}#").url)
      else
        magic = "#{c.crop_width.to_i}x#{c.crop_height.to_i}+#{c.x.to_i}+#{c.y.to_i}"
        image_tag(image.document.thumb(magic).thumb("#{c.width.to_i}x#{c.height.to_i}#").url)
      end
    end
  end

  def site_image_croppings
    @site_image_croppings ||= current_site.image_croppings
  end

  def library_attr
    if current_site && current_site.id.present?
      "data-library=#{builder_site_documents_path(current_site, :link => true)}"
    end
  end

end
