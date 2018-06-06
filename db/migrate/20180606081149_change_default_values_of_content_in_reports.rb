class ChangeDefaultValuesOfContentInReports < ActiveRecord::Migration[5.2]
  def change
    change_column_default :reports, :content, nil
  end
end
