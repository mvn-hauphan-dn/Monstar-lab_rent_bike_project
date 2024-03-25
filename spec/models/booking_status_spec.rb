# frozen_string_literal: true

# == Schema Information
#
# Table name: booking_statuses
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_booking_statuses_on_booking_id  (booking_id)
#  index_booking_statuses_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe BookingStatus do
  describe 'associations' do
    it { should belong_to(:booking) }
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, booking: 1, cancel: 2, payment: 3, finish: 4) }
  end
end
