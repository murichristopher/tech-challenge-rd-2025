require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  let(:three_hours_ago) { 3.hours.ago }
  let(:four_hours_ago)  { 4.hours.ago }
  let(:eight_days_ago)  { 8.days.ago }
  let(:six_days_ago)    { 6.days.ago }

  let!(:active_old_cart) do
    create(:cart, abandoned_at: nil, updated_at: four_hours_ago)
  end

  let!(:active_recent_cart) do
    create(:cart, abandoned_at: nil, updated_at: 1.hour.ago)
  end

  let!(:abandoned_old_cart) do
    create(:cart, abandoned_at: eight_days_ago, updated_at: eight_days_ago)
  end

  let!(:abandoned_recent_cart) do
    create(:cart, abandoned_at: six_days_ago, updated_at: six_days_ago)
  end

  describe "#perform" do
    it "marks old active carts as abandoned and removes old abandoned carts" do
      expect(active_old_cart.abandoned_at).to be_nil
      expect(active_recent_cart.abandoned_at).to be_nil
      expect(Cart.exists?(abandoned_old_cart.id)).to be true
      expect(Cart.exists?(abandoned_recent_cart.id)).to be true

      expect {
        MarkCartAsAbandonedJob.new.perform
      }.to change { Cart.count }.by(-1)

      expect(active_old_cart.reload.abandoned_at).not_to be_nil
      expect(active_recent_cart.reload.abandoned_at).to be_nil
      expect(Cart.exists?(abandoned_old_cart.id)).to be false
      expect(Cart.exists?(abandoned_recent_cart.id)).to be true
    end
  end
end
