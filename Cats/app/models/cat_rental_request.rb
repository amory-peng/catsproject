class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(APPROVED PENDING DENIED),
    message: "%{value} is not valid status" }

  validate :not_valid_date_range

  belongs_to :cat

  def not_valid_date_range
    if overlapping_approved_requests
      errors[:date_range] << "is overlapping"
    end
  end

  def overlapping_approved_requests
    return if self.status == "DENIED"
    cat_rental_requests = CatRentalRequest.where(cat_id: self.cat_id, status: "APPROVED")

    if cat_rental_requests.nil?

      return false
    else
      overlapping_requests(cat_rental_requests)
    end
  end

  def overlapping_pending_requests
    cat_pending_requests = CatRentalRequest.where(cat_id: self.cat_id, status: "PENDING")

    cat_pending_requests.select do |request|
      self.start_date <= request.end_date && self.end_date >= request.start_date
    end
  end

  def overlapping_requests(outer_request = nil)
    cat_rental_requests = outer_request || CatRentalRequest.where(cat_id: self.cat_id)
    cat_rental_requests.each do |request|
      if self.start_date <= request.end_date && self.end_date >= request.start_date
        return true unless self.id == request.id
      end
    end
    false
  end

  def approve!
    self.status = "APPROVED"
    transaction do
      self.save

      self.overlapping_pending_requests.each do |request|
        request.deny! unless self.id == request.id
      end
    end
  end

  def deny!

    self.status = "DENIED"
    self.save!
  end

end
