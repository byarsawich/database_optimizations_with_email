class AddIndexToGenes < ActiveRecord::Migration
  def change
    add_index :genes, :sequence_id
  end
end
