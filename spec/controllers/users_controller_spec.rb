require 'rails_helper'

RSpec.describe 'UsersController' do
    include AuthenticationSpecHelper
  
    before do
      @controller = UsersController.new
    end

    describe 'GET #show' do
        context 'when user is logged in' do
            let(:user) { create(:user) }

            before do
                login_as(user)
            end

            it 'renders the show template' do
                get :show, params: { id: user.id }
                expect(response).to render_template('show')
            end
        end

        context 'when user is not logged in' do
            it 'redirects to login page' do
                get :show, params: { id: 1 }
                expect(response).to redirect_to(login_path)
            end
        end
    end

    describe 'GET #new' do
        it 'assigns a new user to @user' do
            get :new
            expect(assigns(:user)).to be_a_new(User)
        end

        it 'renders the new template' do
            get :new
            expect(response).to render_template('new')
        end
    end

    describe 'POST #create' do
        context 'with valid parameters' do
            let(:valid_params) { attributes_for(:user) }

            it 'creates a new user' do
                expect { post :create, params: { user: valid_params } }.to change(User, :count).by(1)
            end

            it 'sends activation email' do
                expect_any_instance_of(User).to receive(:send_activation_email)
                post :create, params: { user: valid_params }
            end

            it 'redirects to root_url' do
                post :create, params: { user: valid_params }
                expect(response).to redirect_to(root_url)
            end
        end

        context 'with invalid parameters' do
            let(:invalid_params) { attributes_for(:user, email: nil) }

            it 'does not create a new user' do
                expect { post :create, params: { user: invalid_params } }.not_to change(User, :count)
            end

            it 'renders the new template' do
                post :create, params: { user: invalid_params }
                expect(response).to render_template('new')
            end
        end
    end

    describe 'GET #edit' do
        let(:user) { create(:user) }

        context 'when user is logged in and editing own profile' do
            before do
                login_as(user)
                get :edit, params: { id: user.id }
            end

            it 'assigns the requested user to @user' do
                expect(assigns(:user)).to eq(user)
            end

            it 'renders the edit template' do
                expect(response).to render_template('edit')
            end
        end

        context 'when user is not logged in' do
            it 'redirects to login page' do
                get :edit, params: { id: user.id }
                expect(response).to redirect_to(login_path)
            end
        end

        context 'when user is logged in but not editing own profile' do
            let(:other_user) { create(:user) }

            before do
                login_as(user)
                get :edit, params: { id: other_user.id }
            end

            it 'redirects to error page' do
                expect(response).to redirect_to(error_path)
            end
        end
    end

    describe 'PATCH #update' do
        let(:user) { create(:user) }

        context 'with valid parameters' do
            let(:valid_params) { { name: 'New Name' } }

            before do
                login_as(user)
                patch :update, params: { id: user.id, user: valid_params }
            end

            it 'updates user profile' do
                user.reload
                expect(user.name).to eq('New Name')
            end

            it 'redirects to user profile' do
                expect(response).to redirect_to(user)
            end
        end

        context 'with invalid parameters' do
            let(:invalid_params) { { email: nil } }

            before do
                login_as(user)
                patch :update, params: { id: user.id, user: invalid_params }
            end

            it 'does not update user profile' do
                user.reload
                expect(user.email).not_to be_nil
            end

            it 'renders the edit template' do
                expect(response).to render_template('edit')
            end
        end
    end
end
