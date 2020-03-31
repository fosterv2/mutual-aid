require 'rails_helper'

RSpec.describe "listings/show", type: :view do
  before(:each) do
    @listing = assign(:listing, create(:offering))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type.+Offering/m)
  end
end
