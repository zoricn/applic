class AddFieldsToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :fields, :hstore, array: true
  end
end
