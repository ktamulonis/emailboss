class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :to_name
      t.string :from_name
      t.string :to_email
      t.string :from_email
      t.string :subject

      t.timestamps
    end
  end
end
