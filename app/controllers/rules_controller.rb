class RulesController < ApplicationController
  before_filter :maybe_lookup_rule, only: [:edit]
  
  def index
  end

  def edit
    render(layout: false)
  end

  private

  def maybe_lookup_rule
    rule_id = params.fetch('id', nil)
    @rule = Rule.find(rule_id) if rule_id
  end
end
