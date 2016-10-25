class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :transactions, foreign_key: 'user_id', class_name: 'Transaction'
  has_many :invoices, through: :transactions
  has_many :registrations
  has_one  :tradeshift_key
  has_one  :settings_update_event

  def initialize(*args)
    super(*args)
    self.public_id ||= UUID.generate
  end
end
