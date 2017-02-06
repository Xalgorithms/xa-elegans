class SettingsController < ApplicationController
  def index
    @sections = Settings::Defaults.settings['sections'].map(&:to_sym)
    @rules = RuleSerializer.many(Rule.all)
    @default_section = Settings::Defaults.settings['default_section']
    @user_id = current_user.public_id
  end
end
