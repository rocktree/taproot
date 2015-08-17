require 'rails_helper'

describe TemplateFieldCollection do

  before :all do
    @site = Site.find_or_create_by(:title => 'Hello World 123')
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    @home = @site.templates.find('home')
    @fields = @home.fields
  end

  it 'loads a collection of template fields' do
    expect(@fields.all.size).to eq(2)
  end

  it 'can find a specific field' do
    expect(@fields.find('subtitle').class).to eq(TemplateField)
  end

  it 'returns nil if it can not find a field' do
    expect(@fields.find('missing-field')).to eq(nil)
  end

end
