class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
        t.string :title
        t.datetime :deadline
        t.boolean :completed
        t.string :detail

        t.timestamps
    end
  end
end
