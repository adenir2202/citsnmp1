class CreateHosts < ActiveRecord::Migration
  def change
    change_table :hosts do |t|
      t.column(:hostName, :string, limit: 250, default: 'localhost', null: false)  
      t.column(:description, :string, limit: 255, default: :null, null: true) 
      t.column(:snmp_community, :string, limit: 100, default: :null, null: true)
      t.column(:snmp_version, :integer, limit: 2, default: 1, null: false)
      t.column(:snmp_userName, :string, limit: 50, default: :null)
      t.column(:snmp_password, :string, limit:50, default: :null)    
      t.timestamps
    end
  end
end
