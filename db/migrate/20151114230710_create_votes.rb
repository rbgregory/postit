class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :vote
      t.integer :user_id
      t.string :voteable_type   # polymoric true
      t.integer :voteable_id
      t.timestamps
    end
  end
end
