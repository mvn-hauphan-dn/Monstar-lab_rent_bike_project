module Admin::SessionsHelper
  def admin_log_in(admin)
    session[:admin_id] = admin.id
  end

  def admin_logged_in?
    current_admin.present?
  end

  def admin_remember(admin)
    admin.remember
    cookies.permanent.signed[:admin_id] = admin.id
    cookies.permanent[:remember_token] = admin.remember_token
  end

  def admin_forget(admin)
    admin.forget
    cookies.delete(:admin_id)
    cookies.delete(:remember_token)
  end

  def current_admin
    if (admin_id = session[:admin_id])
      @current_admin ||= Admin.find_by(id: admin_id)
    elsif (admin_id = cookies.signed[:admin_id])
      admin = Admin.find_by(id: admin_id)
      if admin && admin.authenticated?(:remember, cookies[:remember_token])
        admin_log_in admin
        @current_admin = admin
      end
    end
  end

  def current_admin?(admin)
    admin == current_admin
  end

  def admin_log_out
    admin_forget(current_admin)
    session.delete(:admin_id)
    @current_admin = nil
  end

  def redirect_back_or(default)
    redirect_to (session[:forwarding_url] || default), status: 303
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
