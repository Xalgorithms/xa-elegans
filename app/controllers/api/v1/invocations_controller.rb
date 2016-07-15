module Api
  module V1
    class InvocationsController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token
      before_filter :maybe_lookup_invocation, only: [:update, :destroy]

      respond_to :json

      def create
        invocation = Invocation.create(invocation_params)
        render(json: invocation)
      end

      def destroy
        if @invocation
          @invocation.destroy
          render(nothing: true, status: :ok)
        else
          render(nothing: true, status: :not_found)
        end
      end
      
      def update
        if @invocation
          @invocation.update_attributes(invocation_params)
          render(json: @invocation)
        else
          render(nothing: true, status: :not_found)
        end
      end

      private
      
      def maybe_lookup_invocation
        id = params.fetch('id', nil)
        @invocation = Invocation.find(id) if id
      end

      def invocation_params
        params.require(:invocation).permit(:account_id, :rule_id)
      end
    end
  end
end
