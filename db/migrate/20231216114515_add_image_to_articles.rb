class AddImageToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :image, :string
  end
end
