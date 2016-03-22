class AddIndexToSequences < ActiveRecord::Migration
  def change
    add_index :sequences, :assembly_id
  end
end
