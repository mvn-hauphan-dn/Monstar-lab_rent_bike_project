require 'rails_helper'

RSpec.describe 'UsersController' do
  include AuthenticationSpecHelper
  let(:user) { create(:user) }

  before do
    @controller = UsersController.new
  end

  describe "GET #new" do
    it "renders the new user template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with invalid attributes" do
      it "invalid user param request" do
        expect {
          post :create, params: { user: attributes_for(:user, email: nil) }
        }.to_not change(User, :count)
      end
      it "re-renders the :new template" do
        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(response).to render_template(:new)
      end

    end

    context "with valid attributes" do
      it "create a user success" do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end
      it "redirects to root_url" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET #edit" do
    before do
      login_as(user)
    end
    
    it "renders the :edit template" do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    before do
      login_as(user)
    end

    context "with invalid attributes" do
      it "invalid user param request" do
        patch :update, params: { id: user.id, user: { email: nil } }
        user.reload
        expect(user.email).not_to eq(nil)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: user.id, user: { email: nil } }
        expect(response).to render_template(:edit)
      end
    end
    
    context "with valid attributes" do
      it "updates the user's profile" do
        patch :update, params: { id: user.id, user: { name: "New Name" } }
        user.reload
        expect(user.name).to eq("New Name")
      end

      it "redirects to the user's profile page" do
        patch :update, params: { id: user.id, user: { name: "New Name" } }
        expect(response).to redirect_to(user)
      end
    end
  end
end
