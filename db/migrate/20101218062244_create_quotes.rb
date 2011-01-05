class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string :grabber_nick
      t.string :grabbed_nick
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :qoutes
  end
end
