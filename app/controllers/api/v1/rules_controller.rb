require 'registry/client'
require 'xa/rules'

module Api
  module V1
    class RulesController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      def create
        transaction = Transaction.find_by(id: params.fetch('transaction_id', nil))
        args = rule_params
        @rule = Rule.create(
          public_id: args.fetch('id', nil),
          version: args.fetch('version', nil),
          transact: transaction)
        # this should be a worker off of an event queue when we're off heroku
        apply_rule(transaction)
        render(json: @rule)
      end

      private

      def apply_rule(tr)
        cl = Registry::Client.new
        cl.rule(@rule.public_id, @rule.version) do |rule_opts|
          r = XA::Rules::Rule.new(rule_opts)
          tr.invoices.each do |inv|
            p interpreter.execute(inv.document, [r])
          end
        end
      end

      def interpreter
        @interpreter ||= XA::Rules::Interpreter.new
      end
      
      def rule_params
        params.require(:rule).permit(:id, :version)
      end
    end
  end
end
