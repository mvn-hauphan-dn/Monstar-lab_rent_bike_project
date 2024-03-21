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
    let!(:user) { create(:user) }
    context 'create with valid user' do
      it 'create a new user' do
        params = {
          name: user.name,
          email: 'testuser@gmail.com',
          password: user.password_digest,
          password_confirmation: user.password_digest,
          role: user.role ,
          phone_number: user.phone_number
        }
        expect { post(:create, params: { user: params }) }.to change(User, :count).by(1)
        expect(flash[:info]).to eq('Please check your email to activate your account.')
        expect(response).to have_http_status(303)
        expect(response).to redirect_to(root_url)
      end
    end
    context 'create with invalid user' do
      it 'renders the new template and status' do
        params = {
          name: user.name,
          email: 'email_wrong',
          password: user.password_digest,
          password_confirmation: user.password_digest,
          role: user.role ,
          phone_number: user.phone_number
        }
        post :create, params: { user: params }
        expect(response).to render_template('new')
        expect(response).to have_http_status(422)
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
      it 'render edit template' do
        params = {
          email: 'test',
        }
        put :update, params: { id: user.id, user: params }
        expect(response).to render_template('edit')
        expect(response).to have_http_status(303)
      end
    end
  end
end
