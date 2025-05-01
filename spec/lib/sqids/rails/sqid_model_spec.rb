RSpec.describe "Sqids::Rails::Model", type: :model do
  # Set up test models
  before do
    # Create test tables if they don't exist - no sqid columns
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

    # Define test models
    class DynamicUser < ApplicationRecord
      include Sqids::Rails::Model

      has_sqid
      has_sqid :long_sqid, min_length: 24

      has_many :dynamic_posts
    end

    class DynamicPost < ApplicationRecord
      include Sqids::Rails::Model

      belongs_to :dynamic_user
      has_sqid
    end
  end

  after do
    # Clean up test models
    Object.send(:remove_const, :DynamicUser)
    Object.send(:remove_const, :DynamicPost)
  end

  let!(:user) { DynamicUser.create!(name: "Test User") }
  let!(:post) { DynamicPost.create!(dynamic_user: user, title: "Test Post") }

  describe "dynamic sqid generation" do
    it "generates sqids dynamically from ID" do
      expect(user.sqid).not_to be_nil
      expect(user.long_sqid).not_to be_nil
      expect(user.long_sqid.length).to be >= 24

      # Create a new sqids instance with the same parameters to verify encoding
      sqids = Sqids.new(min_length: Sqids::Rails.min_length)
      expect(user.sqid).to eq(sqids.encode([ user.id ]))

      long_sqids = Sqids.new(min_length: 24)
      expect(user.long_sqid).to eq(long_sqids.encode([ user.id ]))
    end

    it "returns nil for sqid when record is not persisted" do
      new_user = DynamicUser.new(name: "Unpersisted User")
      expect(new_user.sqid).to be_nil
      expect(new_user.long_sqid).to be_nil
    end

    it "uses the same sqid for the same ID" do
      original_sqid = user.sqid
      reloaded_user = DynamicUser.find(user.id)
      expect(reloaded_user.sqid).to eq(original_sqid)
    end

    it "overrides to_param to use the default sqid" do
      expect(user.to_param).to eq(user.sqid)
    end
  end

  describe "finder methods" do
    it "finds record by sqid" do
      found_user = DynamicUser.find_by_sqid(user.sqid)
      expect(found_user).to eq(user)
    end

    it "finds record by custom sqid attribute" do
      found_user = DynamicUser.find_by_sqid(user.long_sqid, :long_sqid)
      expect(found_user).to eq(user)
    end

    it "raises RecordNotFound for nonexistent sqid" do
      expect {
        DynamicUser.find_by_sqid!("nonexistent")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "works through association" do
      found_post = user.dynamic_posts.find_by_sqid(post.sqid)
      expect(found_post).to eq(post)
    end
  end

  describe "URL helpers" do
    it "uses sqid in URL helpers" do
      # Simulate how Rails would use to_param in URL generation
      expect(user.to_param).to eq(user.sqid)
    end
  end

  describe "with custom configuration" do
    before do
      class CustomConfigUser < ApplicationRecord
        self.table_name = "dynamic_users"

        include Sqids::Rails::Model

        has_sqid :custom_sqid, alphabet: "abcdefghijklmnopqrstuvwxyz", min_length: 10
      end
    end

    after do
      Object.send(:remove_const, :CustomConfigUser)
    end

    let!(:custom_user) { CustomConfigUser.create!(name: "Custom Config User") }

    it "respects custom alphabet and min_length" do
      # Create a sqids instance with the same custom config
      sqids = Sqids.new(
        alphabet: "abcdefghijklmnopqrstuvwxyz",
        min_length: 10
      )

      expect(custom_user.custom_sqid).to eq(sqids.encode([ custom_user.id ]))

      # Find by custom sqid
      found_user = CustomConfigUser.find_by_sqid(custom_user.custom_sqid, :custom_sqid)
      expect(found_user).to eq(custom_user)
    end
  end
end
