class AddFatboyToUsers < ActiveRecord::Migration
  def change

    add_column :users, :age, :string
    add_column :users, :birth_date, :date
    add_column :users, :height, :float
    add_column :users, :cause, :string
    add_column :users, :actual_weight, :float
    add_column :users, :goal_weight, :float
    add_column :users, :start_date, :date
    add_column :users, :goal_date, :date
    add_column :users, :prize, :string

  end
end
