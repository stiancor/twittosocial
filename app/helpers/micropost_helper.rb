# encoding: utf-8

module MicropostHelper

  def micropost_admin_class(micropost)
    'admin-message' if micropost.admin_message?
  end

end