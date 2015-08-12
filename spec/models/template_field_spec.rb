require 'rails_helper'

describe TemplateField do

  before :all do
    @site = Site.find_or_create_by(
      :title => 'Hello World 123',
      :slug => 'hello-world-123',
      :git_url => 'git@github.com:topicdesign/topkit-test-template.git',
      :uid => '69b0386a13b44503881d516a2c19cc4a2bf48974d552a397'
    )
    system("cd #{Rails.root}/projects && git clone #{@site.git_url} #{@site.slug}")
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
