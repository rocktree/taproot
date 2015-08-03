module Application
  module RenderingHelper

    def partial(name, options = {})
      options = options.merge(:partial => name)
      render(options)
    end

  end
end
