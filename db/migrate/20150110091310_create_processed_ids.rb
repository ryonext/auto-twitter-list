class CreateProcessedIds < ActiveRecord::Migration
  def change
    create_table :processed_ids do |t|
      t.integer :client_id, limit: 8
      t.integer :target_id, limit: 8

      t.timestamps null: false
    end
    add_index :processed_ids , [:client_id, :target_id], unique: true
  end
end
