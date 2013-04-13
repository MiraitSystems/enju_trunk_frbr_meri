# -*- encoding: utf-8 -*-
class Item < ActiveRecord::Base
  scope :recent, where(['items.created_at >= ?', Time.zone.now.months_ago(1)])
  has_one :exemplify
  has_one :manifestation, :through => :exemplify

  #validates :item_identifier, :allow_blank => true, :uniqueness => true, :format => {:with => /\A[0-9A-Za-z_]+\Z/}
  validates :item_identifier, :allow_blank => false, :uniqueness => true, :format => {:with => /^[a-zA-Z]{1,4}-\d{5}-\d{3}/}
  validates :url, :url => true, :allow_blank => true, :length => {:maximum => 255}
  validates_date :acquired_at, :allow_blank => true

  normalize_attributes :item_identifier

  attr_accessor :library_id, :manifestation_id, :use_restriction_id

  def title
    manifestation.try(:original_title)
  end

  def select_acquired_at
    if self.acquired_at
      return self.acquired_at.strftime("%Y%m")
    else
      return Time.now.strftime("%Y%m")
    end
  end

  private
  def self.to_format(num)
    num.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end

  def self.get_object_method(obj,array)
    _obj = obj.send(array.shift)
    return get_object_method(_obj, array) if array.present?
    return _obj
  end

end

# == Schema Information
#
# Table name: items
#
#  id                          :integer         not null, primary key
#  call_number                 :string(255)
#  item_identifier             :string(255)
#  circulation_status_id       :integer         not null
#  checkout_type_id            :integer         default(1), not null
#  created_at                  :datetime
#  updated_at                  :datetime
#  deleted_at                  :datetime
#  shelf_id                    :integer         default(1), not null
#  include_supplements         :boolean         default(FALSE), not null
#  checkouts_count             :integer         default(0), not null
#  owns_count                  :integer         default(0), not null
#  resource_has_subjects_count :integer         default(0), not null
#  note                        :text
#  curl                         :string(255)
#  price                       :integer
#  lock_version                :integer         default(0), not null
#  required_role_id            :integer         default(1), not null
#  state                       :string(255)
#  required_score              :integer         default(0), not null
#  acquired_at                 :datetime
#  bookstore_id                :integer
#

