class TransactionsController < ApplicationController
  def index
    @transactions = TransactionSerializer.many(current_user.transactions)
    @associations = all_related(:associations, AssociationSerializer)
    @documents = all_related(:documents, DocumentSerializer)
    @invoices = all_related(:invoices, InvoiceSerializer)
    @rules = RuleSerializer.many(Rule.all)
  end

  def show
  end

  private

  def all_related(k, serializer_klass)
    all = current_user.transactions.inject({}) do |all, txm|
      txm.send(k).inject(all) do |all, o|
        all.merge(o.id => o)
      end
    end

    serializer_klass.many(all.values, :transaction)
  end
end
