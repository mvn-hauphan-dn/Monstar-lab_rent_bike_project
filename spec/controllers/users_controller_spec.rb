# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController' do
  include AuthenticationSpecHelper

  before do
    @controller = UsersController.new
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    it 'render the :new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    let(:valid_user_params) do
      {
        name: 'valid_name',
        email: 'valid_email@example.com',
        password: 'valid_password',
        password_confirmation: 'valid_password',
        role: :renter,
        phone_number: '12345678'
      }
    end

    let(:invalid_user_params) do
      {
        name: 'valid_name',
        email: 'valid_email@',
        password: 'valid_password',
        password_confirmation: 'valid_password',
        role: :renter,
        phone_number: '12345678'
      }
    end

    context 'create with valid user' do
      it 'create a new user' do
        post :create, params: { user: valid_user_params }

        expect(response).to have_http_status(303)
      end
    end

    context 'fail to create a user' do
      shared_examples 'create fail' do |description, invalid_user_params|
        let(:response) { post :create, params: { user: attributes_for(:user, invalid_user_params) } }
        context description.to_s do
          it { expect(response).to have_http_status(422) }
        end
      end

      it_behaves_like 'create fail', 'with email nil', { email: nil }
      it_behaves_like 'create fail', 'with name nil', { name: nil }
      it_behaves_like 'create fail', 'with email has wrong format', { email: 'invalid_email' }
      it_behaves_like 'create fail', 'with duplicate emails', { email: 'example@email.com' } do
        let!(:user) { create(:user, email: 'example@email.com') }
      end
      it_behaves_like 'create fail', 'with password length less than 6', { password: 1234 }
      it_behaves_like 'create fail', 'with name length greater than 50', { name: Faker::Lorem.characters(number: 60) }
      it_behaves_like 'create fail', 'with email length greater than 255', { email: "#{Faker::Lorem.characters(number: 256)}@example.com" }
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }

    before do
      login_as(user)
    end

    it 'update a user successfully' do
      put :update, params: { id: user.id, user: { name: 'test update' } }
      expect(flash[:success]).to eq 'User profile updated'
    end

    context 'when update with invalid user' do
      shared_examples 'update fail' do |description, params|
        let(:response) { put :update, params: { id: user.id, user: params } }
        context description.to_s do
          params.each do |param, value|
            it { expect(user.send(param)).not_to eq(value) }
          end
          it { expect(response).to have_http_status(303) }
          it { expect(response).to render_template('edit') }
        end
      end

      it_behaves_like 'update fail', 'with email nil', { email: nil }
      it_behaves_like 'update fail', 'with name nil', { name: nil }
      it_behaves_like 'update fail', 'with email email has wrong format', { email: 'invalid_email' }
      it_behaves_like 'update fail', 'with duplicate emails', { email: 'example@email.com' } do
        before do
          create(:user, email: 'example@email.com')
        end
      end
      it_behaves_like 'update fail', 'with password length less than 6', { password: 1234 }
      it_behaves_like 'update fail', 'with name length greater than 50', { name: Faker::Lorem.characters(number: 60) }
      it_behaves_like 'update fail', 'with email length greater than 255', { email: "#{Faker::Lorem.characters(number: 256)}@example.com" }
    end
  end
end
