require 'rails_helper'

RSpec.describe 'UsersController' do
  include AuthenticationSpecHelper

  before do
    @controller = UsersController.new
  end

  describe "GET #new" do
    let(:user) { create(:user) }

    before do
      login_as(user)
    end

    it "render the :new template" do
      get :new
      expect(response).to render_template("new")
    end
    
  end

  describe "POST #create" do
    let(:valid_user_params) do
      {
        name: 'valid_name',
        email: 'valid_email@example.com',
        password: 'valid_password',
        password_confirmation: 'valid_password',
        role: :renter ,
        phone_number: '12345678'
      }
    end
    context 'create with valid user' do
      it 'create a new user' do
        expect { post(:create, params: valid_user_params) }.to have_http_status(303)
      end
    end

    it "fail to create a user" do
      post :create, params: { user: {
          name: Faker::Name.name, 
          email: "testEmail", 
          password: user.password,
          password_confirmation: user.password,
          activated_at: Time.zone.now,
          role: user.role
        }
      } 

      expect(response).to have_http_status(422)
    end
    
  end

  describe "PUT #update" do
    let(:user) { create(:user) }

    before do
      login_as(user)
    end

    it "update a user successfully" do
      put :update, params: { id: user.id, user:{name: "test update"}}
      expect(flash[:success]).to eq 'User profile updated'
    end

    it "update a user fail" do
      put :update, params: { id: user.id, user:{email: "test"}}
      expect(response).to have_http_status(303)
    end
    
  end

end
