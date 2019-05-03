class User < ApplicationRecord
  has_one :account

  has_secure_password

  validates :cpf, presence: true, uniqueness: true
  validates :name, presence: true
end
