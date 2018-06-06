class Report < ApplicationRecord
  belongs_to :user

  mount_uploader :content, ReportUploader

  validates_presence_of :content, :name
end
