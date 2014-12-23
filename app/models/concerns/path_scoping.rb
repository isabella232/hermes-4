module PathScoping
  extend ActiveSupport::Concern

  included do
    def self.within(path)
      case ActiveRecord::Base.connection.class.to_s
      when /PostgreSQLAdapter/
        where("path_re ~* ?", path.presence || '/')
      when /Mysql2Adapter/
        where("path_re REGEXP ?", path.presence || '/')
      end
    end
  end
end
