class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :category, :name, null: false, limit: 126

      t.decimal :unit_amount, null: false, precision: 10, scale: 2
      t.integer :quantity, null: false, default: 1

      t.integer :period_count, null: false, default: 1
      t.integer :period_unit, limit: 1, null: false

      t.boolean :income, :budget, :sales_tax, null: false, default: false

      t.text :notes

      t.timestamps
    end

    add_index :items, %i[category name], unique: true
    add_index :items, %i[income category name]
  end
end
