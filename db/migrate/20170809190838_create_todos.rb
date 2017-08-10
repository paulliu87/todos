class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
        t.string :title
        t.datetime :deadline
        t.boolean :completed
        t.boolean :overdue
        t.string :detail
        t.references :user, foreign_key: true
        t.timestamps
    end
  end
end
