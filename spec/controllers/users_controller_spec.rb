# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include AuthenticationSpecHelper

  before do
    @controller = UsersController.new
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'render the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with invalid parameters' do
      let(:invalid_params) { { user: attributes_for(:user, email: nil) } }

      before do
        post :create, params: invalid_params
      end

      it 'does not create a new user' do
        expect { post :create, params: invalid_params }.not_to change(User, :count)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'with valid parameters' do
      let(:valid_params) do
        { user: attributes_for(:user) }
      end

      it 'creates a new user' do
        expect do
          post :create, params: valid_params
        end.to change(User, :count).by(1)
      end

      it 'sends activation email' do
        expect_any_instance_of(User).to receive(:send_activation_email)
        post :create, params: valid_params
      end

      it 'sets flash message' do
        post :create, params: valid_params
        expect(flash[:info]).to eq('Please check your email to activate your account.')
      end

      it 'redirects to root_url' do
        post :create, params: valid_params
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    before do
      login_as(user)
      get :show, params: { id: user.id }
    end

    it 'renders the :show template' do
      get :show, params: { id: user.id }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }

    before do
      login_as(user)
      get :edit, params: { id: user.id }
    end

    it 'renders the :edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:invalid_attributes) { attributes_for(:user, name: nil) }
    let(:valid_attributes) { attributes_for(:user, name: 'New Name') }

    context 'with invalid parameters' do
      before do
        login_as(user)
        patch :update, params: { id: user.id, user: invalid_attributes }
      end

      it 'does not update the user' do
        user.reload
        expect(user.name).not_to be_nil
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'with valid parameters' do
      before do
        login_as(user)
        patch :update, params: { id: user.id, user: valid_attributes }
      end

      it 'updates the user' do
        user.reload
        expect(user.name).to eq(valid_attributes[:name])
      end

      it 'sets flash success message' do
        expect(flash[:success]).to eq('User profile updated')
      end

      it 'redirects to user show page' do
        expect(response).to redirect_to(user)
      end
    end
  end
end
