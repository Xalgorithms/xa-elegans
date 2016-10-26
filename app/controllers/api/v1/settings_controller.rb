module Api
  module V1
    class SettingsController < ActionController::Base
      before_filter :maybe_lookup_user,         only: [:index]
      
      def index
        if @user
          rv = {}.tap do |o|
            o[:tradeshift] = TradeshiftKeySerializer.serialize(@user.tradeshift_key) if @user.tradeshift_key
          end
          render(json: rv)
        else
          render(nothing: true, status: :not_found)
        end
      end

      private
      
      def maybe_lookup_user
        user_id = params.fetch('user_id', nil)
        begin
          @user = User.find_by(public_id: user_id) if user_id
        rescue
          Rails.logger.warn("! Failed lookup (user_id=#{user_id})")
        end
      end
    end
  end
end
