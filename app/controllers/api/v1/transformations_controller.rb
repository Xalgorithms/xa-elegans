module Api
  module V1
    class TransformationsController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter       :maybe_lookup_transformation, only: [:show]

      def show
        if @transformation
          render(json: TransformationSerializer.serialize(@transformation))
        else
          render(nothing: true, status: :not_found)
        end
      end

      def index
        render(json: TransformationSerializer.many(Transformation.all))
      end

      private

      def maybe_lookup_transformation
        id = params.fetch(:id, nil)
        begin
          @transformation = Transformation.find_by(public_id: id) if id
        rescue
          Rails.logger.warn("! Failed lookup (id=#{id})")
        end
      end
    end
  end
end
