# frozen_string_literal: true

module AuthenticationSpecHelper
  include SessionsHelper
  include Admin::SessionsHelper

  def login_as(user)
    if user.instance_of?(User)
      log_in(user)
    elsif user.instance_of?(Admin)
      admin_log_in(user)
    end
  end
end
