class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :mentioning_id
      t.integer :mentioned_id

      t.timestamps
    end
    add_index :relationships, [:mentioning_id, :mentioned_id], unique: true
  end
end
