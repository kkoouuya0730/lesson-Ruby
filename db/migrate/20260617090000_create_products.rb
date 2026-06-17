class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :original_price, precision: 10, scale: 2
      t.text :images, array: true, default: [], null: false
      t.string :category, null: false
      t.integer :stock, null: false, default: 0
      t.decimal :rating, precision: 3, scale: 2, null: false, default: 0
      t.integer :review_count, null: false, default: 0
      t.boolean :featured, null: false, default: false
      t.text :tags, array: true, default: [], null: false

      t.timestamps
    end

    add_index :products, :category
    add_index :products, :featured
  end
end
