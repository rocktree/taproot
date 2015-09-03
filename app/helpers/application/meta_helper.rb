module Application
  module MetaHelper

    def meta_title
      @meta_title ||= t('app.title')
    end

  end
end
