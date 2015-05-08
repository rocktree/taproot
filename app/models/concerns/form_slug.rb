module FormSlug
  extend ActiveSupport::Concern

  included do
    after_save :sluggify_slug
  end

  def sluggify_slug
    if title.present? && slug.blank?
      s = create_slug
      update_column(:slug, s)
      s
    end
  end

  def create_slug
    slug = clean_slug(self.title.downcase.gsub(/\&/, ' and '))
    dups = self.form.form_fields.where(:slug => slug) - [self]
    slug = "#{slug}_#{self.id}" if dups.count > 0
    slug
  end

  def clean_slug(s)
    clean_slug = s.gsub(/[^a-zA-Z0-9 \-]/, "") # remove all bad characters
    clean_slug.gsub!(/\ /, "_") # replace spaces with underscores
    clean_slug.gsub!(/\-+/, "_") # replace repeating underscores
    clean_slug
  end

  def to_param
    slug
  end

end
