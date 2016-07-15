module ApplicationHelper
  def format_user_name(u)
    u.full_name ? "#{u.full_name} (#{u.email})" : u.email
  end
end
