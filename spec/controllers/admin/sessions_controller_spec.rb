# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::SessionsController' do
  include AuthenticationSpecHelper

  before do
    @controller = Admin::SessionsController.new
  end

  describe 'POST #create' do
    let(:admin) { create(:admin) } # Assuming you have a factory for creating admins

    context 'with valid credentials' do
      it 'logs in the admin' do
        post :create, params: { email: admin.email, password: admin.password }

        expect(session[:admin_id]).to eq(admin.id)
      end

      it 'sets the remember cookie if `remember_me` is checked' do
        post :create, params: { email: admin.email, password: admin.password, remember_me: '1' }

        expect(cookies.permanent.signed[:admin_id]).to eq(admin.id)
      end

      it 'redirects to the admin root path' do
        post :create, params: { email: admin.email, password: admin.password }

        expect(response).to redirect_to(admin_root_path(host: 'localhost'))
      end
    end

    context 'with invalid credentials' do
      it 'renders the `new` template' do
        post :create, params: { email: admin.email, password: 'wrong_password' }

        expect(flash[:danger]).to eq('Invalid email/password combination')
        expect(response).to render_template('new')
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:admin) { create(:admin) }

    before do
      login_as(admin)
      delete :destroy
    end

    it 'logs out the admin' do
      expect(session[:admin_id]).to be_nil
    end

    it 'redirects to the admin login path' do
      expect(response).to redirect_to(admin_login_path)
    end

    it 'returns a 303 status' do
      expect(response).to have_http_status(303)
    end
  end
end
