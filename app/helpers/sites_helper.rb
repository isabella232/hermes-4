module SitesHelper

  def protocol_chooser(f)
    f.select :protocol, options_for_select(['http', 'https'], f.object.protocol)
  end

end
