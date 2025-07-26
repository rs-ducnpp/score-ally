class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.boolean :show_total_point, default: false
      t.integer :room_type, null: false, default: 0
      t.integer :limit_point
      t.integer :limit_round
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :rooms, :room_type
  end
end
