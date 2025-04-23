class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :job_applications

  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: :password_required?

  def password_required?
    new_record? || password.present?
  end

  def admin?
    role == 'Admin'
  end

  def candidate?
    role == 'Candidate'
  end
end