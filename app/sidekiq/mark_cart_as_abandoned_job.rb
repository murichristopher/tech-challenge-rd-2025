class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    mark_abandoned_carts
    remove_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    Cart
      .active
      .inactive_for(3.hours.ago)
      .update_all(abandoned_at: Time.current)
  end

  def remove_old_abandoned_carts
    Cart
      .abandoned
      .where("abandoned_at < ?", 7.days.ago)
      .destroy_all
  end
end