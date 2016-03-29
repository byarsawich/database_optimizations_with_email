class Report < ActiveRecord::Base
  has_attached_file :uploaded_report
  validates_attachment_content_type :uploaded_report, content_type: /\Atext\/.*\Z/
end
