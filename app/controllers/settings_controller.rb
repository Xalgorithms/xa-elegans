class SettingsController < ApplicationController
  def index
    @sections = Settings::Defaults.settings['sections'].map(&:to_sym)
    @default_section = Settings::Defaults.settings['default_section']
  end
end
