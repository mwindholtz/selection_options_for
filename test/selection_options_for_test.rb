## ruby -Itest -Ilib test/selection_options_for_test.rb
require 'test_helper'

#
# setup three classes for these tests
#
# 1. ModelUnderTest  -- declare selection_options_for to be tested
# 2. SiblingOfModelUnderTest -- make sure that no meta-level leaks occur
# 3. SubClassOfModel -- should have it's own copy of class variables
#

class SiblingOfModelUnderTest < SuperModel::Base
  extend SelectionOptionsFor::ModelAdditions
end

class ModelUnderTest < SuperModel::Base
  extend SelectionOptionsFor::ModelAdditions
      
  selection_options_for :status_option,
            [:partial,        'P', 'Partial Registration'],
            [:active,         'A', 'Active'],
            [:changing_email, 'E', 'Active, Changing Email'],  
            [:inactive,       'I',  'Inactive'],
            [:forgot_pw,      'F', 'Active, Forgot Password' ]

  selection_options_for :payment_method_option,
            [:basic, 'B', 'Basic'],
            [:cash,  'C',  'Cash Account'],
            [:cc,    'R', 'Credit Card Account']
            
  selection_options_for :sorted_option,
            [:none,         'H', 'Honorary Member'],
            [:member,       'M', 'CSM - Certified ScrumMaster'],
            [:pract,        'P', 'CSP - Certified Scrum Practitioner'],
            [:cst,      'T', 'CST - Certified Scrum Trainer'],
            [:icst, 'I', 'ICST - Certified Scrum Trainer (inactive)']
            
 end

class SubClassOfModel < ModelUnderTest
  selection_options_for :payment_method_option,
            [:advanced, 'A', 'Advanced'],
            [:ecash,    'E', 'ECash Account']
end

class SelectionOptionsForTest < Test::Unit::TestCase
  def setup
    @model  = ModelUnderTest
  end  

  def test_should_provide_symbols
    expected = {"B"=>:basic, "C"=>:cash, "R"=>:cc}
    assert_equal expected, ModelUnderTest.payment_method_option_symbols
  end

  def test_should_provide_symbol
    target =  @model.new
    target.status_option_forgot_pw!
    assert_equal :forgot_pw, @model.status_option_symbols[target.status_option]
    assert_equal :forgot_pw, target.status_option_symbol
  end
  
  def test_symbol_generation
    target =  @model.new
    # forget PW
    target.status_option_forgot_pw!
    assert target.status_option_forgot_pw?
    assert !target.status_option_active?
    assert !target.status_option_changing_email?
    assert !target.status_option_inactive?
    assert !target.status_option_partial?
    # active
    target.status_option_active!
    assert !target.status_option_forgot_pw?
    assert target.status_option_active?
    assert !target.status_option_changing_email?
    assert !target.status_option_inactive?
    assert !target.status_option_partial?
    # active
    target.status_option_inactive!
    assert !target.status_option_forgot_pw?
    assert !target.status_option_active?
    assert !target.status_option_changing_email?
    assert target.status_option_inactive?
    assert !target.status_option_partial?
  end

  def test_sibling_of_target_not_effected_by_class_methods
      SiblingOfModelUnderTest.payment_method_options
      flunk "Should throw Exception" 
      rescue NoMethodError => ex
         assert true
      rescue
        flunk "wrong exception thrown"
  end

  def test_each_subclass_has_own_symbols    
    assert_equal [["Advanced", "A"], ["ECash Account", "E"]] ,
                  SubClassOfModel.payment_method_options.sort 
  end

  def test_payment_method_option_array
    assert_equal [["Basic", "B"], ["Cash Account", "C"], ["Credit Card Account", "R"]],
                  @model.payment_method_options.sort 
  end

  def test_default_status
    target =  @model.new
    target.status_option_forgot_pw!
    assert_equal 'Active, Forgot Password', target.status_option_label
    target.status_option = 'A'
    assert_equal 'Active', target.status_option_label
  end

  def test_status_option_array    
    assert_equal [["Active", 'A'],
     ["Active, Changing Email", "E"],
     ["Active, Forgot Password", "F"],
     ["Inactive", "I"],
     ["Partial Registration", 'P']].sort ,  
     @model.status_options.sort    
  end

  def test_default_payment_method_option_hash
    expected = {"B"=>"Basic", "C"=>"Cash Account", "R"=>"Credit Card Account"}
    assert_equal expected, @model.payment_method_option_hash
  end
  
  def test_status_option_js_list
    assert_equal "['Active', 'Active, Changing Email', 'Active, Forgot Password', 'Inactive', 'Partial Registration']",
                 @model.status_option_js_list
  end
  
  def test_sorted_option_array
    assert_equal [["CSM - Certified ScrumMaster", "M"],
                  ["CSP - Certified Scrum Practitioner", "P"],
                  ["CST - Certified Scrum Trainer", "T"],
                  ["Honorary Member", "H"],
                  ["ICST - Certified Scrum Trainer (inactive)", "I"]] ,  
                  @model.sorted_options 
  end 
  
end
