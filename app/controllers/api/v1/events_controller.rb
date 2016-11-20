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
        @old_events ||= {
          'transaction_add_invoice' => {
            klass: TransactionAddInvoiceEvent,
            args: [:transaction_public_id, :url],
          },
          'transaction_bind_source' => {
            klass: TransactionBindSourceEvent,
            args: [:transaction_public_id, :source],
          },
        }

        @events ||= {
          'transaction_open' => {
            args: [:user_id],
          },
          'transaction_close' => {
            args: [:transaction_id],
          },
          'invoice_push' => {
            args: [:transaction_id, :document_id],
          },
          'transformation_add' => {
            args: [:name, :src],
          },
          'settings_update' => {
            args: [:user_id, tradeshift: [:key, :secret, :tenant_id]],
          },
          'transformation_destroy' => {
            args: [:transformation_id],
          },
          'transaction_associate_rule' => {
            args: [:transaction_id, :rule_id, :transformation_id],
          },
          'register' => {
            args: [:user_id, :token],
          },
          'transaction_execute' => {
            args: [:transaction_id],
          },
          'tradeshift_sync' => {
            args: [:user_id],
          },
          'invoice_destroy' => {
            args: [:invoice_id],
          },
        }
      
        k = params[:event_type]
        if k
          if @old_events.include?(k)
            args = params.require("#{k}_event").permit(*@old_events[k][:args])
            
            @old_events[k][:klass].create(args.merge(event: Event.create(public_id: UUID.generate, event_type: params[:event_type])))
          elsif @events.include?(k)
            args = params.require("payload").permit(*@events[k][:args])
            EventService.process(params[:event_type], args)
          end
        else
          nil
        end
      end
    end
  end
end
