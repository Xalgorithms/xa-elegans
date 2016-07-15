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
            interpreter.execute(inv.document, [r]).each do |rule_change|
              rule_change.each do |k, ch|
                doc_id = Documents::Change.create(key: k, original: ch.original, mutated: ch.mutated)
                Change.create(rule: @rule, invoice: inv, document_id: doc_id)
              end
            end
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
