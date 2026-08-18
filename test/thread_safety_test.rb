# frozen_string_literal: true

require_relative 'test_helper'

# libswe is not thread-safe; every native call must funnel through the global
# lock so two threads can't be inside the C library at once. We assert a native
# call made from a second thread blocks until the lock is released.
class ThreadSafetyTest < Minitest::Test
  def assert_serialized_through_lock
    order = []
    holding = Queue.new

    holder = Thread.new do
      Swisseph::LOCK.synchronize do
        holding << true
        sleep 0.1
        order << :lock_released
      end
    end

    holding.pop # ensure the holder owns the lock before the native call starts
    caller_thread = Thread.new do
      yield
      order << :native_call
    end

    [holder, caller_thread].each(&:join)
    assert_equal %i[lock_released native_call], order
  end

  def test_native_swe_method_is_serialized_through_the_lock
    assert_serialized_through_lock { Sweph.swe_julday(2000, 1, 1, 12.0, 1) }
  end

  def test_shorthand_alias_is_serialized_through_the_lock
    assert_serialized_through_lock { Sweph.julday(2000, 1, 1, 12.0, 1) }
  end
end
