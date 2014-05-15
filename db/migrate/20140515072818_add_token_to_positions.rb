class AddTokenToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :token, :string
  end
end
