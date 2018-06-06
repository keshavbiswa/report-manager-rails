class ChangeApprovedInReports < ActiveRecord::Migration[5.2]
  def change
    change_column_default :reports, :approved, false
  end
end
