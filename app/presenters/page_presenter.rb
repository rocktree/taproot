class PagePresenter

  def initialize(obj)
    @obj = obj
  end

  def status
    @obj.published? ? 'published' : 'draft'
  end

  def status_icon
    if @obj.published?
      "<i class=\"icon-checkmark color-success\"></i>".html_safe
    else
      "<i class=\"icon-draft color-dark-lightest\"></i>".html_safe
    end
  end

end
