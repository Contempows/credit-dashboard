class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :order_desc, -> { order('updated_at DESC') }

  def self.paginate_and_order(page, items)
    paginate(page: page, per_page: items).order_desc
  end
end
