class PagePresenter

  def initialize(obj)
    @obj = obj
  end

  def status
    @obj.published? ? 'published' : 'draft'
  end

  # def first_name
  #   return '' if @obj.name.nil?
  #   @obj.name.split(' ').first
  # end

  # def last_name
  #   return '' if @obj.name.nil?
  #   @obj.name.split(' ').last
  # end

end
