# frozen_string_literal: true

require 'monitor'
require 'swisseph/swisseph'

# Shorthand alias
Sweph = Swisseph unless defined?(Sweph)
module Swisseph
  # Automatically create shorthand aliases without the 'swe_' prefix
  # e.g. Swisseph.julday instead of Swisseph.swe_julday
  singleton_methods.each do |method_name|
    next unless method_name.to_s.start_with?('swe_')

    alias_name = method_name.to_s.delete_prefix('swe_')
    define_singleton_method(alias_name, method(method_name)) unless respond_to?(alias_name)
  end
end

module Swisseph
  # The Swiss Ephemeris C library (libswe) keeps process-global state and a
  # shared file descriptor for its data files, so it is NOT thread-safe: two
  # threads executing inside it at once can segfault the process. Every native
  # call is serialized through one global re-entrant lock so concurrent threads
  # -- e.g. a multi-threaded Puma app plus in-process background workers --
  # can never be inside libswe simultaneously. A single-threaded caller never
  # contends for the lock; concurrent callers are serialized (a brief wait, not
  # a segfault).
  LOCK = Monitor.new
end

# Wrap every current singleton method (the native swe_* methods and the
# shorthand aliases defined above) so each public entry point takes the lock.
Swisseph.singleton_class.prepend(
  Module.new do
    lock = Swisseph::LOCK
    Swisseph.singleton_methods(false).each do |name|
      define_method(name) do |*args, &block|
        lock.synchronize { super(*args, &block) }
      end
    end
  end
)
