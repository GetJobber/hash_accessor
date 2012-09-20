require 'test/unit'

require File.expand_path("../lib/hash_accessor", File.dirname(__FILE__))

class HashAccessorTest < Test::Unit::TestCase

  class TestClassWithHash
    include HashAccessor
    attr_accessor :options

    hash_accessor :options, :unspecified_variable
    hash_accessor :options, :test_integer, :type => :integer
    hash_accessor :options, :test_decimal, :type => :decimal
    hash_accessor :options, :test_bool, :type => :bool
    hash_accessor :options, :test_array_1, :type => :array, :collects => lambda{|item|
      item.gsub(/li_/, "").to_i 
    }
    hash_accessor :options, :test_array_2, :type => :array, :reject_blanks => true

    def initialize
      options = {}
    end
  end

  def setup
    @tester = TestClassWithHash.new
  end

  def test_accessors_being_added_correct
    assert @tester.respond_to?(:unspecified_variable)

    @tester.unspecified_variable = "some test"
    assert_equal "some test", @tester.unspecified_variable
  end

  def test_no_sharing_of_variables
    @tester.unspecified_variable = "some test"
    assert_equal "some test", @tester.unspecified_variable
    assert TestClassWithHash.new.unspecified_variable.blank?
  end

  def test_accessors_being_casted_correctly
    @tester.test_integer = "3"
    @tester.test_decimal = "3"
    assert_equal 3, @tester.test_integer
    assert_equal 3.to_d, @tester.test_decimal
  end

  def test_boolean_question_mark_method_being_added
    assert !@tester.test_bool?
    @tester.test_bool = true
    assert @tester.test_bool?
  end

  def test_array_collect_method
    assert_equal [], @tester.test_array_1
    @tester.test_array_1 = ["li_1", "li_2", "li_3"]
    assert_equal [1, 2, 3], @tester.test_array_1
  end

  def test_array_reject_blank_method
    @tester.test_array_2 = ["", "1", "2"]
    assert_equal ["1", "2"], @tester.test_array_2
  end

end
