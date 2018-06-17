class AddUuidToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :uuid, :string
  end
end
