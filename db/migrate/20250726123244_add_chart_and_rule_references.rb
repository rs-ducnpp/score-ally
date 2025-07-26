class AddChartAndRuleReferences < ActiveRecord::Migration[8.0]
  def change
    add_reference :charts, :rule, null: false, foreign_key: true
    add_reference :rooms, :chart, null: true, foreign_key: true
    add_reference :rooms, :rule, null: true, foreign_key: true
  end
end
