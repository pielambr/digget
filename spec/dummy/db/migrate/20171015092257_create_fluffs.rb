class CreateFluffs < ActiveRecord::Migration[5.0]
  def change
    create_table :fluffs do |t|
      t.string :some_text
      t.datetime :some_date
      t.time :some_time
      t.integer :some_int
      t.float :some_float

      t.timestamps
    end
  end
end
