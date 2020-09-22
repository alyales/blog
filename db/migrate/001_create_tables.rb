class CreateTables < ActiveRecord::Migration[4.2]

  def change
    create_table :users do |t|
      t.string :login, null: false
    end

    create_table :ips do |t|
      t.string :address, null: false
    end

    create_table :ips_users, :id => false do |t|
      t.column :ip_id, :integer, null: false
      t.column :user_id, :integer, null: false
    end

    add_index :ips_users, [:ip_id, :user_id], unique: true

    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.integer :marks_count, default: 0
      t.float  :avg_mark
      t.belongs_to :ip, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
    end

    create_table :marks do |t|
      t.integer :mark, null: false
      t.belongs_to :post, foreign_key: true, null: false
    end

    add_index(:users, :login, unique: true)
    add_index(:ips, :address, unique: true)
  end

end
