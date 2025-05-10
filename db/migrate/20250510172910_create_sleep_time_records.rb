class CreateSleepTimeRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :sleep_time_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_time
      t.datetime :wake_time
      
      t.timestamps
    end
  end
end
