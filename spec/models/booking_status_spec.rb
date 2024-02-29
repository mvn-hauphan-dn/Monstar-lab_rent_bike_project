require 'rails_helper'

RSpec.describe BookingStatus do
  describe 'associations' do
    it { should belong_to(:booking) }
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, booking: 1, cancel: 2, finish: 3) }
  end
end
