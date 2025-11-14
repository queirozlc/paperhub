class ChangeDocContentToBinary < ActiveRecord::Migration[8.1]
  def change
    remove_column :documents, :content, :jsonb
    add_column :documents, :content, :binary
  end
end
