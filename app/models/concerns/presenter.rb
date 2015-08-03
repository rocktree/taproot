module Presenter
  extend ActiveSupport::Concern

  included do
  end

  def p
    "#{self.class}Presenter".constantize.new(self)
  end

  def method_missing(method, *arguments, &block)
    begin
      super
    rescue
      p.send(method)
    end
  end

end
