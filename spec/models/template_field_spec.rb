require 'rails_helper'

describe TemplateField do

  before :all do
    @site = Site.find_or_create_by(:title => 'Hello World 123')
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    @home = @site.templates.find('home')
    @fields = @home.fields
    @subtitle = @fields.find('subtitle')
  end

  it 'has a pseudo method for the name' do
    expect(@subtitle.name).to eq('subtitle')
  end

  it 'has a pseudo method for the label' do
    expect(@subtitle.label).to eq('Subtitle')
  end

  it 'has a pseudo method for the type' do
    expect(@subtitle.type).to eq('string')
  end

  it 'has a hash of attributes' do
    expect(@subtitle.attributes[:name]).to eq('subtitle')
  end

end
