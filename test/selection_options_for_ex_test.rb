## ruby -Itest test/selection_options_for_ex_test.rb
require 'test_helper'

#
# test bad data and exceptions
#

class ModelUnderTest < ActiveRecord::Base
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :price_option,             :string
    
  begin  
    selection_options_for :price_option,
            [:basic,  'Basic' ],
            [:cash,   'Cash Account '],
            [:cc, 'R','Credit Card Account'],
            123            
            
  rescue RuntimeError => ex
    @@exception_num = ex
  end

   def self.exception_num
     @@exception_num
   end

  begin  
    selection_options_for :status_option,
            [:basic,  'Basic' ],
            'Cash Account',
            [:cc, 'R','Credit Card Account']
            
  rescue RuntimeError => ex
    @@exception_string = ex
  end

   def self.exception_string
     @@exception_string
   end


end

class TranslateOptionsForExTest < Test::Unit::TestCase
  def setup
    @model  = ModelUnderTest
  end

  def test_invalid_num
    assert_equal RuntimeError, ModelUnderTest.exception_num.class
    assert_equal "Invalid item [123] in :price_option of type [Fixnum]. Expected Array",
                  ModelUnderTest.exception_num.message
  end

  def test_invalid_string
    assert_equal RuntimeError, ModelUnderTest.exception_string.class
    assert_equal "Invalid item [Cash Account] in :status_option of type [String]. Expected Array",
                  ModelUnderTest.exception_string.message
  end


end
