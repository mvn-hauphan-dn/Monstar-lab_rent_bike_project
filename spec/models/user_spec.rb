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
require 'rails_helper'

RSpec.describe User do
  ######################
  #### Associations ####
  ######################

  describe 'associations' do
    subject { build(:user) }

    it { should have_one_attached(:avatar) }

    it { should have_many(:bikes).dependent(:destroy) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_secure_password }
  end

  #####################
  #### Validations ####
  #####################

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  #############
  ### Enums ###
  #############

  describe 'enums' do
    it { should define_enum_for(:role).with_values([
        :renter,
        :lessor
      ])
    }
  end
end
