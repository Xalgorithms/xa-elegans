module Api
  module V1
    class DocumentsController < ActionController::Base
      def create
        @document = Document.create(src: request.raw_post, public_id: UUID.generate)
        render(json: { id: @document.public_id })
      end

      def show
        doc = Document.find_by(public_id: params['id'])
        if doc
          render(json: doc.content)
        else
          render(nothing: true, status: :not_found)
        end
      end
    end
  end
end
