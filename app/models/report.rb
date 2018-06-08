class Report < ApplicationRecord
  belongs_to :user, optional: true

  validates_presence_of :content, :name
end
