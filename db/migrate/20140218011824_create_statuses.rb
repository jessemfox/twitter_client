class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|

      t.string :body, :limit => 140, :null => false
      t.string :twitter_statuses_id, :null => false
      t.string :twitter_user_id, :null => false

      t.timestamps
    end

    add_index :statuses, :twitter_statuses_id, :unique => true

  end
end
