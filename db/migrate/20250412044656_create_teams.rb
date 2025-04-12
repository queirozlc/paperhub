class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.belongs_to :owner, null: false, foreign_key: { to_table: :users }, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
