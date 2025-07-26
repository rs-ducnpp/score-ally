class CreateRules < ActiveRecord::Migration[8.0]
  def change
    create_table :rules do |t|
      t.integer :point_type, null: false, default: 0
      t.integer :point, null: false, default: 0
      t.text :description
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
