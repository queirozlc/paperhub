defmodule Paperhub.Accounts.Team do
  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Accounts,
    data_layer: AshPostgres.DataLayer

  alias Ash.Resource.Info

  postgres do
    table "teams"
    repo Paperhub.Repo

    references do
      reference :owner, index?: true
    end
  end

  actions do
    defaults [:read, :destroy]

    create :default_team do
      accept [:name]
      transaction? true

      change relate_actor(:owner)
      change Paperhub.Accounts.Team.Changes.AssociateMember
      change Paperhub.Accounts.Team.Changes.SetOwnerCurrentTeam
    end
  end

  defimpl Ash.ToTenant, for: __MODULE__ do
    def to_tenant(%{id: id}, resource) do
      if Info.data_layer(resource) == AshPostgres.DataLayer &&
           Info.multitenancy_strategy(resource) == :context do
        "team_#{id}"
      else
        id
      end
    end
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :owner, Paperhub.Accounts.User, allow_nil?: false

    many_to_many :members, Paperhub.Accounts.User do
      through Paperhub.Accounts.Membership
      source_attribute_on_join_resource :team_id
      destination_attribute_on_join_resource :member_id
    end
  end
end
