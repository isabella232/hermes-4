class AddProtocolToSites < ActiveRecord::Migration
  def change
    add_column :sites, :protocol, :string, default: 'http', null: false
  end
end
