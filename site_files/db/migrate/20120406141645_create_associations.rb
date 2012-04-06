class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :french_associations do |t|
      t.string :name
      t.string :address
      t.string :phone_no
      t.string :postal_code, :limit => 5
      t.string :email
      t.string :website
      t.string :fax
      t.string :consulate
      t.string :department_id
    end
    
    create_table :departments do |t|
      t.string  :code
      t.string  :name
    end
  end

  def self.down
    drop_table :french_associations
    drop_table :departments
  end
end
