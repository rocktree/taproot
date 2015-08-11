require 'rails_helper'

describe Frontmatter do

  before :all do
    @template = "#{Rails.root}/spec/support/basic_template.html.erb"
    @response = Frontmatter.parse(@template)
  end

  it 'will load config into a yaml hash' do
    expect(@response.first.class).to eq(Hash)
  end

  it 'loads a test field at the proper place' do
    expect(@response.first['fields']['subtitle']['label']).to eq('Subtitle')
  end

  it 'also returns content without the frontmatter' do
    expect(@response.last).to_not include('title')
  end

end