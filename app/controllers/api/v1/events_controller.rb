module Api
  module V1
    class EventsController < ActionController::Base
      def create
        @event = make
        render(json: { url: api_v1_event_path(id: @event.event.public_id) })
      end
      
      def show
        @event = Event.where(public_id: params['id']).first
        render(json: EventSerializer.serialize(@event))
      end

      private

      def make
        @events = {
          'transaction_open' => {
            klass: TransactionOpenEvent,
            args: [:user_id],
          },
          'transaction_close' => {
            klass: TransactionCloseEvent,
            args: [:transaction_public_id],
          },
          'invoice_push' => {
            klass: InvoicePushEvent,
            args: [:transaction_public_id, :document_public_id],
          },
          'transformation_add' => {
            klass: TransformationAddEvent,
            args: [:name],
          },
        }
      
        k = params[:event_type]
        args = params.require("#{k}_event").permit(*@events[k][:args])
        
        @events[k][:klass].create(args.merge(event: Event.create(public_id: UUID.generate, event_type: params[:event_type])))
      end
    end
  end
end
