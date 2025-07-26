class CreateCharts < ActiveRecord::Migration[8.0]
  def change
    create_table :charts do |t|
      t.integer :point, null: false, default: 0
      t.integer :round, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
