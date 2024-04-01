# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController' do
  include AuthenticationSpecHelper
  let(:user) { create(:user) }

  before do
    @controller = UsersController.new
  end

  describe 'GET #new' do
    it 'renders the new user template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    shared_examples 'invalid user model attributes' do |description, attributes|
      attributes.each do |attribute, value|
        let(:response) { post :create, params: { user: attributes_for(:user, attribute => value) } }
        context description.to_s do
          it { expect { response }.to_not change(User, :count) }
          it { expect(response).to render_template('new') }
          it { expect(response).to have_http_status(422) }
        end
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'invalid user model attributes', 'email is nil', { email: nil }
      it_behaves_like 'invalid user model attributes', 'email has wrong format', { email: 'invalid email' }
      it_behaves_like 'invalid user model attributes', 'email greater than 255', { email: "#{Faker::Lorem.characters(number: 246)}@gmail.com" }
      it_behaves_like 'invalid user model attributes', 'name is nil', { name: nil }
      it_behaves_like 'invalid user model attributes', 'name greater than 50', { name: Faker::Lorem.characters(number: 51) }
      it_behaves_like 'invalid user model attributes', 'password less than 6', { password: Faker::Lorem.characters(number: 5) }
      it_behaves_like 'invalid user model attributes', 'duplicate email', { email: 'duplicate@email.com' } do
        let!(:user) { create(:user, email: 'duplicate@email.com') }
      end
    end

    context 'with valid attributes' do
      it 'create a user success' do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end
      it 'redirects to root_url' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #edit' do
    before do
      login_as(user)
    end

    it 'renders the :edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    before do
      login_as(user)
    end

    shared_examples 'invalid user model attributes' do |description, attributes|
      attributes.each do |attribute, value|
        context description.to_s do
          let(:response) { patch :update, params: { id: user.id, user: attributes } }
          it {
            user.reload
            expect(user.send(attribute)).not_to eq(value)
          }
          it { expect(response).to render_template(:edit) }
        end
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'invalid user model attributes', 'email is nil', { email: nil }
      it_behaves_like 'invalid user model attributes', 'email has wrong format', { email: 'invalid email' }
      it_behaves_like 'invalid user model attributes', 'email greater than 255', { email: "#{Faker::Lorem.characters(number: 246)}@gmail.com" }
      it_behaves_like 'invalid user model attributes', 'name is nil', { name: nil }
      it_behaves_like 'invalid user model attributes', 'name greater than 50', { name: Faker::Lorem.characters(number: 51) }
      it_behaves_like 'invalid user model attributes', 'password less than 6', { password: Faker::Lorem.characters(number: 5) }
      it_behaves_like 'invalid user model attributes', 'duplicate email', { email: 'duplicate@email.com' } do
        before do
          create(:user, email: 'duplicate@email.com')
        end
      end
    end

    context 'with valid attributes' do
      it "updates the user's profile" do
        patch :update, params: { id: user.id, user: { name: 'New Name' } }
        user.reload
        expect(user.name).to eq('New Name')
      end

      it "redirects to the user's profile page" do
        patch :update, params: { id: user.id, user: { name: 'New Name' } }
        expect(response).to redirect_to(user)
      end
    end
  end
end
