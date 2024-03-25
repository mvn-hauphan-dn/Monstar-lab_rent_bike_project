require 'rails_helper'

RSpec.describe 'Admin::UsersController' do
  include AuthenticationSpecHelper

  before do
    @controller = Admin::UsersController.new
  end

  describe "GET #index" do
    let(:admin) { create(:admin) }

    before do
      login_as(admin)
    end

    it "assigns @users" do
        users = create_list(:user, 2)
        get :index
        expect(assigns(:users)).to match_array(users)      
    end

    it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }

    before do
      login_as(admin)
    end

    context "when user is a lessor" do
      it "assign @bikes" do
        user.update(role: :lessor)
        bike = create(:bike, user: user)
        get :show, params: { id: user.id }
        expect(assigns(:bikes)).to include(bike)
      end

      it "renders lessor_template" do
        user.update(role: :lessor)
        bike = create(:bike, user: user)
        get :show, params: { id: user.id }
        expect(response).to render_template(:lessor_show)
      end
    end

    context "when user is a renter" do
      it "assign @bookings" do
        user.update(role: :renter)
        booking = create(:booking, user: user)
        get :show, params: { id: user.id }
        expect(assigns(:bookings)).to include(booking)
      end

      it "renders renter_template" do
        user.update(role: :renter)
        booking = create(:booking, user: user)
        get :show, params: { id: user.id }
        expect(response).to render_template(:renter_show)
      end
    end
  end
end
