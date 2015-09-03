class TemplateCollection

  def initialize(site)
    @site = site
    @config = @site.config['templates']
  end

  def all
    templates
  end

  def find(template)
    templates.select { |t| t.name == template }.first
  end

  private

    def templates_root
      "#{Rails.root}/projects/#{@site.slug}/templates"
    end

    def templates
      @templates ||= begin
        return [] if @config.nil?
        templates = []
        @config.each do |name, data|
          templates << Template.new(name, data, @site)
        end
        templates
      end
    end

end
