class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships, primary_key: [ :member_id, :team_id ] do |t|
      t.belongs_to :member, null: false, foreign_key: { to_table: :users }, index: true
      t.belongs_to :team, null: false, foreign_key: true, index: true
      t.integer :role, null: false

      t.timestamps
    end
  end
end
