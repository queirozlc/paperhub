class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.belongs_to :team, null: false, foreign_key: true, index: true
      t.string :title
      t.string :description
      t.integer :visibility, null: false, default: 0

      t.timestamps
    end

    add_check_constraint :documents, "visibility IN (0, 1, 2)", name: 'check_visibility'
  end
end
