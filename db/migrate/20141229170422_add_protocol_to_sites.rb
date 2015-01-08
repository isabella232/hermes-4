class AddProtocolToSites < ActiveRecord::Migration
  def change
    add_column :sites, :protocol, :string, default: 'https', null: false
  end
end
