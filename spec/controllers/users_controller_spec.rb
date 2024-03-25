require 'rails_helper'

RSpec.describe "UsersController" do
include AuthenticationSpecHelper
  before do
    @controller = UsersController.new
  end

  describe 'GET #new' do   
    context 'Render template new' do
      it 'renders the `new` template' do
        get :new
        expect(response).to render_template('new')
      end
    end
  end

  describe 'POST #create' do  
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
        expect { post(:create, params: { user: valid_user_params }) }.to change(User, :count).by(1)
        expect(flash[:info]).to eq('Please check your email to activate your account.')
        expect(response).to have_http_status(303)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'create with invalid user' do
      it 'case name, email is nil' do
        post :create, params: { user: attributes_for(:user, email: nil, name: nil) }
        expect(response).to render_template('new')
      end

      it 'case email has wrong format' do
        post :create, params: { user: attributes_for(:user, email: "invalid_email") }
        expect(response).to have_http_status(422)
      end

      it "case duplicate emails" do
        user = create(:user, email: "example@email.com")
        expect {
          post :create, params: { user: attributes_for(:user, email: "example@email.com") }
        }.to_not change(User, :count)
      end

      it "case password length less than 6" do
        expect {
          post :create, params: { user: attributes_for(:user, password:1234) }
        }.to_not change(User, :count)
      end

      it "case name length greater than 50" do
        expect {
          post :create, params: { user: attributes_for(:user, name:Faker::Lorem.characters(number: 60)) }
        }.to_not change(User, :count)
      end

      it "case email length greater than 255" do
        expect {
          post :create, params: { user: attributes_for(:user, email:Faker::Lorem.characters(number: 256) + "@example.com") }
        }.to_not change(User, :count)
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create :user }
    before do
      login_as(user)
    end

    context 'Update with valid user' do
      it 'update user info' do
        params = {
          name: 'update test',
          email: 'test1@gmail.com',
        }
      put :update, params: { id: user.id, user: params }
      user.reload
      params.keys.each do |key|
        expect(user.attributes[key.to_s]).to eq params[key]
      end
      expect(flash[:success]).to eq 'User profile updated'
      end
    end

    context 'update with invalid user' do
      it 'case edit name, email is nil' do
        put :update, params: { id: user.id, user: {name: nil, email: nil} }
        expect(user.email).not_to eq(nil)
        expect(user.name).not_to eq(nil)
      end

      it 'case edit email has wrong format' do
        put :update, params: { id: user.id, user: {email: "invalid_email"} }
        expect(user.email).not_to eq("invalid_email")
      end

      it "case edit duplicate emails" do
        user = create(:user, email: "example@email.com")
        put :update, params: { id: user.id, user: {email: "example@email.com"} }
        expect(response).to have_http_status(303)
      end

      it "case edit password length less than 6" do
        put :update, params: { id: user.id, user: {password:1234} }
        expect(response).to have_http_status(303)
      end

      it "case edit name length greater than 50" do
        put :update, params: { id: user.id, user: {name:Faker::Lorem.characters(number: 60)} }
        expect(response).to render_template('edit')
      end

      it "case edit email length greater than 255" do
        put :update, params: { id: user.id, user: { email:Faker::Lorem.characters(number: 256) + "@example.com"} }
        expect(response).to render_template('edit')
      end
    end
  end
end