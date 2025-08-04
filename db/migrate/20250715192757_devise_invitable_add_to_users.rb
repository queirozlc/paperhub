class DeviseInvitableAddToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, foreign_key: { to_table: :users }, index: true
      t.references :invited_team, foreign_key: { to_table: :teams }, index: true
      t.integer    :invitation_role
      t.integer    :invitations_count, default: 0
      t.index      :invitation_token, unique: true # for invitable
    end
  end
end
