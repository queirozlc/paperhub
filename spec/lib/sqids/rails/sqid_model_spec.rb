RSpec.describe "Sqids::Rails::Model", type: :model do
  before do
    ActiveRecord::Schema.define do
      create_table :dynamic_users, force: true do |t|
        t.string :name
        t.timestamps null: false
      end

      create_table :dynamic_posts, force: true do |t|
        t.references :dynamic_user
        t.string :title
        t.timestamps null: false
      end
    end

    dynamic_user = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      has_sqid
      has_sqid :long_sqid, min_length: 24

      has_many :dynamic_posts
    end

    dynamic_post = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      belongs_to :dynamic_user
      has_sqid
    end

    stub_const("DynamicUser", dynamic_user)
    stub_const("DynamicPost", dynamic_post)
  end

  let!(:user) { DynamicUser.create!(name: "Test User") }
  let!(:post) { DynamicPost.create!(dynamic_user: user, title: "Test Post") }

  describe "dynamic sqid generation" do
    it { expect(user.sqid).not_to be_nil }

    it { expect(user.long_sqid).not_to be_nil }

    it { expect(user.long_sqid.length).to be >= 24 }

    it { expect(user.to_param).to eq(user.sqid) }


    it "encodes sqid with default settings" do
      sqids = Sqids.new(min_length: Sqids::Rails.min_length)
      expect(user.sqid).to eq(sqids.encode([ user.id ]))
    end

    it "encodes long_sqid with custom min_length" do
      long_sqids = Sqids.new(min_length: 24)
      expect(user.long_sqid).to eq(long_sqids.encode([ user.id ]))
    end

    it "returns nil sqid for non-persisted record" do
      new_user = DynamicUser.new(name: "Unpersisted User")
      expect(new_user.sqid).to be_nil
    end

    it "returns nil long_sqid for non-persisted record" do
      new_user = DynamicUser.new(name: "Unpersisted User")
      expect(new_user.long_sqid).to be_nil
    end

    it "generates the same sqid for the same ID" do
      reloaded_user = DynamicUser.find(user.id)
      expect(reloaded_user.sqid).to eq(user.sqid)
    end
  end

  describe "finder methods" do
    it "finds user by sqid" do
      found_user = DynamicUser.find_by_sqid(user.sqid)
      expect(found_user).to eq(user)
    end

    it "finds user by custom sqid attribute" do
      found_user = DynamicUser.find_by_sqid(user.long_sqid, :long_sqid)
      expect(found_user).to eq(user)
    end

    it "raises RecordNotFound for nonexistent sqid" do
      expect {
        DynamicUser.find_by_sqid!("nonexistent")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "finds post through association using sqid" do
      found_post = user.dynamic_posts.find_by_sqid(post.sqid)
      expect(found_post).to eq(post)
    end
  end

  describe "with custom configuration" do
    before do
      custom_config_user = Class.new(ApplicationRecord) do
        self.table_name = "dynamic_users"

        include Sqids::Rails::Model

        has_sqid :custom_sqid, alphabet: "abcdefghijklmnopqrstuvwxyz", min_length: 10
      end

      stub_const("CustomConfigUser", custom_config_user)
    end

    let!(:custom_user) { CustomConfigUser.create!(name: "Custom Config User") }

    it "generates correct custom_sqid" do
      sqids = Sqids.new(alphabet: "abcdefghijklmnopqrstuvwxyz", min_length: 10)
      expect(custom_user.custom_sqid).to eq(sqids.encode([ custom_user.id ]))
    end

    it "finds user by custom_sqid" do
      found_user = CustomConfigUser.find_by_sqid(custom_user.custom_sqid, :custom_sqid)
      expect(found_user).to eq(custom_user)
    end
  end
end
