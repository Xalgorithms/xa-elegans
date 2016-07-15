class Invoice < ActiveRecord::Base
  belongs_to :account
  has_many :invocations, through: :account

  def as_json(opts = {})
    lopts = {
      only: [:id, :effective],
      include: {
        account: {
          only: [:id, :name]
        },
        invocations: {
          only: [:id],
          include: {
            rule: {
              only: [:name],
            },
            assignments: {
              only: [:id],
              methods: [:content, :name],
            },
          },
        }
      },
    }
    super(opts.merge(lopts))
  end
end
