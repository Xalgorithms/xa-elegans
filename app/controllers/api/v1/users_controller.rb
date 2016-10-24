module Api
  module V1
    class UsersController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter       :maybe_lookup_user, only: [:show]

      def show
        if @user
          render(json: UserSerializer.serialize(@user))
        else
          render(nothing: true, status: :not_found)
        end
      end

      private

      def maybe_lookup_user
        id = params.fetch(:id, nil)
        begin
          if id
            @user = User.find_by(public_id: id)
            @user = User.find_by(email: id) unless @user
          end
        rescue
          Rails.logger.warn("! Failed lookup (id=#{id})")
        end
      end
    end
  end
end
