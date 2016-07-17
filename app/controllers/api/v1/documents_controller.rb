module Api
  module V1
    class DocumentsController < ActionController::Base
      def create
        @document = Document.create(src: request.raw_post, public_id: UUID.generate)
        render(json: { id: @document.public_id })
      end
    end
  end
end
