require 'settings/defaults'

module ApplicationHelper
  def format_user_name(u)
    u.full_name ? "#{u.full_name} (#{u.email})" : u.email
  end

  def global_sections
    Settings::Defaults.global_sections.map(&:to_sym)
  end
end
