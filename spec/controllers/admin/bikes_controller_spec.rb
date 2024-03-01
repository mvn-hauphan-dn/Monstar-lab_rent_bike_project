require 'rails_helper'

RSpec.describe 'Admin::BikesController' do
  include AuthenticationSpecHelper

  before do
    @controller = Admin::BikesController.new
  end

  describe "GET #show" do
    let(:admin) { create(:admin) }
    let(:bike) { create(:bike) }

    before do
      login_as(admin)
    end

    it "assigns the requested bike to @bike" do
      get :show, params: { id: bike.id }
      expect(assigns(:bike)).to eq(bike)
    end

    it "renders the show template" do
      get :show, params: { id: bike.id }
      expect(response).to render_template("show")
    end
  end

  # TODO: update later
  # describe "GET #index"
  # describe "GET #update"
end