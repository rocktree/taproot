class UserPresenter

  def initialize(obj)
    @obj = obj
  end

  def name
    @obj.name || @obj.email
  end

  def first_name
    return '' if @obj.name.nil?
    @obj.name.split(' ').first
  end

  def last_name
    return '' if @obj.name.nil?
    @obj.name.split(' ').last
  end

end
