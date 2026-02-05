# frozen_string_literal: true

require 'swisseph/swisseph'

# Compatibility alias
Swe4r = Swisseph unless defined?(Swe4r)

module Swisseph
  class << self
    # Automatically create shorthand aliases without the 'swe_' prefix
    # e.g. Swisseph.julday instead of Swisseph.swe_julday
    singleton_methods.each do |method_name|
      next unless method_name.to_s.start_with?('swe_')

      alias_name = method_name.to_s.delete_prefix('swe_')
      alias_method alias_name, method_name unless respond_to?(alias_name)
    end
  end
end
