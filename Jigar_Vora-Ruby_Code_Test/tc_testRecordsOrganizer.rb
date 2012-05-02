require File.join(File.dirname(__FILE__),'recordsOrganizer')
require 'test/unit'

class TestRecordsOrganizer < Test::Unit::TestCase

  def test_simple
	goldenKey = ""
  	File.open('model_output.txt', 'r') {|aFile| goldenKey = aFile.readlines}
	assert_equal(goldenKey, RecordsOrganizer.new().output)
  end
end


