class CreateFlyers < ActiveRecord::Migration
  def self.up
    create_table :flyers do |t|
      t.integer :topic_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flyers
  end
end
