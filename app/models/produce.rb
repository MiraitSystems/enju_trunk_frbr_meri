class Produce < ActiveRecord::Base
  belongs_to :patron
  belongs_to :manifestation
  delegate :original_title, :to => :manifestation, :prefix => true

  validates_associated :patron, :manifestation
  validates_presence_of :patron, :manifestation
  validates_uniqueness_of :manifestation_id, :scope => :patron_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list :scope => :manifestation
  attr_accessible :patron, :manifestation, :patron_id, :manifestation_id

  paginates_per 10

  def reindex
    patron.try(:index)
    manifestation.try(:index)
  end
end

# == Schema Information
#
# Table name: produces
#
#  id               :integer         not null, primary key
#  patron_id        :integer         not null
#  manifestation_id :integer         not null
#  position         :integer
#  type             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

