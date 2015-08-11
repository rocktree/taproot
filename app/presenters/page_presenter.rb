class PagePresenter

  def initialize(obj)
    @obj = obj
  end

  def status
    @obj.published? ? 'published' : 'draft'
  end

end
