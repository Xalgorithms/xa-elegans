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
        render(json: @rule)
      end

      private

      def rule_params
        params.require(:rule).permit(:id, :version)
      end
    end
  end
end
