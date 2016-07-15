class Change < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :rule

  def document
    Documents::Change.new(document_id)
  end
end
