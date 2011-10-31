class CreateVoteModel < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :ip_address
      t.integer :report_id
    end
  end

  def self.down
    drop_table :votes
  end
end
