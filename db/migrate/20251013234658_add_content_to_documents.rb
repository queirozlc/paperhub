class AddContentToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :content, :json
  end
end
