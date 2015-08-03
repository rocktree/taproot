class UserPresenter

  def initialize(obj)
    @obj = obj
  end

  def display_name
    @obj.name || @obj.email
  end

  def first_name
    return @obj.email if @obj.name.nil?
    @obj.name.split(' ').first
  end

  def last_name
    return @obj.email if @obj.name.nil?
    @obj.name.split(' ').last
  end

  def title
    display_name
  end

end
