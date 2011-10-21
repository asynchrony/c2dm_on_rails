require 'active_model'

module C2dm
  class Base
    class Errors < ActiveModel::Errors
    end

    def self.table_name # :nodoc:
      self.to_s.gsub("::", "_").tableize
    end
    
  end
end
