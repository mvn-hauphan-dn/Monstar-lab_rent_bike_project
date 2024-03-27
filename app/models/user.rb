# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  activated_at      :datetime
#  activation_digest :string
#  address           :string
#  email             :string
#  name              :string
#  password_digest   :string
#  phone_number      :string
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  role              :integer          default("renter")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_one_attached :avatar
  has_many :bikes, dependent: :destroy
  has_many :bookings, dependent: :destroy

  before_save   :downcase_email
  before_create :create_activation_digest

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i

  enum role: %i[renter lessor]

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  scope :order_by_newest, -> { order(updated_at: :desc) }
  scope :filter_by_name_or_email, lambda { |params_filter|
                                    if params_filter.present?
                                      where('name LIKE ? OR email LIKE ?', "%#{params_filter}%", "%#{params_filter}%")
                                    end
                                  }

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activated?
    activated_at.present?
  end

  def activate
    update_columns(activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
