class AddFileToReports < ActiveRecord::Migration
  def change
    add_attachment :reports, :uploaded_report
  end
end
