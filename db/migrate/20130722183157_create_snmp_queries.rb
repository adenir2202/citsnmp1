class CreateSnmpQueries < ActiveRecord::Migration
  def change
    create_table :snmp_queries do |t|
    	t.column(:OID, :string, limit: 64, default: 'new hash', null: false)	
      t.column(:name, :string, limit: 100, default: 'new_col', null: false) 
      t.column(:text, :string, limit: 32760, default: 'x', null: false)
    	t.column(:xml, :string, limit: 32760, default: '<>', null: false)	
    	t.column(:description, :string, limit: 255, default: :null, null: true)	
      t.timestamps
    end
  end
end
