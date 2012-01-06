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
    else
      raise ArgumentError, "unknown type #{s['type']}"
    end
  end
  module_function :parse
end
