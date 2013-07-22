class CreateSnmpsrvs < ActiveRecord::Migration
  def change
    create_table :snmpsrvs do |t|
      t.string :OID
      t.text :OID_name
      t.text :descricao
      t.timestamps
    end
  end
end
