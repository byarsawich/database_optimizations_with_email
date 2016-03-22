class AddIndexToHits < ActiveRecord::Migration
  def change
    add_index :hits, :subject_id
    add_index :hits, :subject_type
    add_index :hits, :percent_similarity
  end
end
