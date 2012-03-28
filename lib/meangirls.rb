module Meangirls
  $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
  
  class ReinsertNotAllowed < RuntimeError; end
  class DeleteNotAllowed < RuntimeError; end

  require 'set'
  require 'meangirls/crdt'
  
  # Transforms a JSON data structure into a CRDT datatype.
  def parse(s)
    case s['type']
    when '2p-set'
      TwoPhaseSet.new s
    when 'lww-set'
      LWWSet.new s
    else
      raise ArgumentError, "unknown type #{s['type']}"
    end
  end
  module_function :parse

  # An ISO8601 time as close to the current time as possible, with the
  # additional constraint that successive calls to this method will return
  # monotonically increasing values.
  #
  # TODO: fold counter inside of time fraction
  def timestamp
    @i ||= 0
    "#{Time.now.utc.iso8601}.#{@i += 1}"
  end
  module_function :timestamp
end
