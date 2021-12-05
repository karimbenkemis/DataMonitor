class CreateExperiments < ActiveRecord::Migration[6.1]
  def change
    create_table :experiments do |t|
      t.belongs_to :researcher, foreign_key: true
      t.float :threshold
      t.float :data, array: true, default: []
      t.integer :signal, array: true, default: []

      t.timestamps
    end
  end
end
