class CreateNewsarticles < ActiveRecord::Migration
  def change
    create_table :newsarticles do |t|
      t.text :title
      t.text :title_modified
      t.text :body_raw
      t.datetime :published_first_at
      t.string :status
      t.integer :author_id

      t.timestamps
    end
  end
end
