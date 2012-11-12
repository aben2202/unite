class AddGeneralAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string,		uniqueness: { case_sensitive: false }
    add_column :users, :age, :integer
    add_column :users, :zipcode, :integer
  end
end
