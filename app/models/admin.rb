class Admin < ApplicationRecord
  attr_accessor :remember_token

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  enum role: [:root, :admin]

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  scope :order_by_newest, -> { order(updated_at: :desc) }
  scope :search_by_name_or_email, -> (params_search){ where('name LIKE ? OR email LIKE ?', "%#{params_search}%", "%#{params_search}%") if params_search.present? }

  def Admin.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Admin.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Admin.new_token
    update_attribute(:remember_digest, Admin.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  private
    def downcase_email
      self.email = email.downcase
    end
end
