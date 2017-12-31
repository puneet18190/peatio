class CreateChatmessages < ActiveRecord::Migration
  def change
    create_table :chatmessages do |t|
      t.string :author
      t.text :message

      t.timestamps
    end
  end
end
