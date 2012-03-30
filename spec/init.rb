require 'bacon'
require 'mocha-on-bacon'
require "#{File.expand_path(File.dirname(__FILE__))}/crdt"
require "#{File.expand_path(File.dirname(__FILE__))}/set"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/meangirls"

Bacon.summary_on_exit
