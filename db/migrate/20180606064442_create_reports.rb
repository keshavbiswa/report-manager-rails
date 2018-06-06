class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.text :name
      t.boolean :approved
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
