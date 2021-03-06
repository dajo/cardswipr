class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description

      t.timestamps
    end

    create_table :attendance_entries do |t|
      t.string :first_name
      t.string :nickname
      t.string :last_name
      t.integer :upi
      t.string :netid
      t.string :email
      t.string :college_name
      t.string :college_abbreviation
      t.integer :class_year
      t.string :school
      t.string :telephone
      t.string :address
      t.belongs_to :event

      t.timestamps
    end
  end
end
