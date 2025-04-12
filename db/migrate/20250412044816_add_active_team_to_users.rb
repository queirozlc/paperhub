class AddActiveTeamToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :active_team, foreign_key: { to_table: :teams }, index: true
  end
end
