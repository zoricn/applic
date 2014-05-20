class CreatePositionFields < ActiveRecord::Migration
  def change
    create_table :position_fields do |t|
      t.string :name
      t.string :field_type
      t.boolean :required
      t.string :title
      t.belongs_to :position, index: true

      t.timestamps
    end
  end
end
