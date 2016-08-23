module Api
  module V1
    class EventsController < ActionController::Base
      def create
        @event = make
        if @event
          render(json: { url: api_v1_event_path(id: @event.event.public_id) })
        else
          render(nothing: true, status: :not_found)
        end
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
            args: [:name, :src],
          },
          'transformation_destroy' => {
            klass: TransformationDestroyEvent,
            args: [:public_id],
          },
          'transaction_associate_rule' => {
            klass: TransactionAssociateRuleEvent,
            args: [:transaction_public_id, :rule_public_id, :transformation_public_id],
          },
          'register' => {
            klass: RegisterEvent,
            args: [:user_id, :token],
          },
          'transaction_execute' => {
            klass: TransactionExecuteEvent,
            args: [:transaction_public_id],
          },
        }
      
        k = params[:event_type]
        if k
          args = params.require("#{k}_event").permit(*@events[k][:args])
          
          @events[k][:klass].create(args.merge(event: Event.create(public_id: UUID.generate, event_type: params[:event_type])))
        else
          nil
        end
      end
    end
  end
end
