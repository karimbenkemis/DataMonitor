class Researcher < ApplicationRecord
    has_many :experiments, dependent: :destroy
    has_secure_password

    validates :email,
        presence: true,
        uniqueness: true
end
