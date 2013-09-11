class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :user_id
      t.string :content
      t.integer :retweets
      t.datetime :t_created_at
      t.integer :id_int, :limit => 8, uniqueness: true
      t.timestamps
    end
  end
end
