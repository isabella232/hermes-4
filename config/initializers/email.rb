module Hermes

  config = Rails.root.join('config', config)
  config = YAML.load_file(config).fetch(Rails.env)
  config.each do |k,v|
    v.symbolize_keys! if v.respond_to?(:symbolize_keys!)
    ActionMailer::Base.send("#{k}=", v)
  end

end
