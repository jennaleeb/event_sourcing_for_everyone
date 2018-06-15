class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :email
      t.boolean :is_active
      t.string :plan_tier

      t.timestamps
    end
  end
end
