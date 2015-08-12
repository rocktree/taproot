require 'rails_helper'

describe TemplateFieldCollection do

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
