# SelectionOptionsFor

This code allows you to keep the display labels in the model 
when the DB holds only a 1 character flag.
and when the code requires symbolic references to the value to use in algorithms

## Installation

Add this line to your application's Gemfile:

    gem 'selection_options_for'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install selection_options_for

## Usage


SelectionOptionsFor
===================

 This code allows you to keep the display labels in the model 
 when the DB holds only a 1 character flag.
 and when the code requires symbolic references to the value to use in algorithms

 element 0 of the array passed in is always the logical symbol
 If a 2-element Array is passed in, [key, label] and the first letter of label is the DB value
 If a 3-element Array is passed in, [key, DB value, label] 
 Any other type passed in throws an error

 Limitations: Don't use this if you will run reports directly against the DB 
 In that case, the reports will not have access to the display labels


class Article < ActiveRecord::Base
        selection_options_for :file_type_option,
           [:pdf,    'PDF'],
           [:html,   'HTML'],
           [:msword, 'MS-Word']
           [:text,   'X', 'Textfile']
end

adds the following CLASS METHODS to Article

* file_type_options
  returns a array of 2-value arrays suitable to fill a select tag
  The second example shows how to start the selection on a blank
$  <%= select :article, :file_type_option, Article.file_type_options %>
$  <%= select :article, :file_type_option,  [['','']] + Article.file_type_options %>

$  assert_equal  ["MS-Word", "PDF", "HTML"],   Article.file_type_option_hash.values
$  assert_equal "['MS-Word', 'PDF', 'HTML']",  Article.file_type_option_js_list
 
$ file_type_option_symbols
  returns hash of symbols

adds the following INSTANCE METHODS to Article

$ file_type_option_hash
$ file_type_option
  returns the single character value as in the db

$ file_type_option_label
  returns the current values label

$ file_type_option_symbol
  returns the current values symbol

methods ending in '?' return boolean if the value is set
methods ending in '!' set the value
  
$ file_type_option_pdf?  
$ file_type_option_pdf! 

$ file_type_option_html?
$ file_type_option_html!

$ file_type_option_msword?
$ file_type_option_msword!

example #1: Selection list

  article = Article.new
  article.file_type_option_pdf!
  assert_equal 'P',   article.file_type_option
  assert_equal :pdf,  article.file_type_symbol
  assert_equal true,  article.file_type_option_pdf?
  assert_equal 'PDF', article.file_type_option_label
  assert_equal [["MS-Word", "M"], ["PDF", "P"], ["HTML", "H"]], 
               Article.file_type_options
  assert_equal({"M"=>"MS-Word", "P"=>"PDF", "H"=>"HTML"}, 
               Article.file_type_option_hash) 
  
  assert_equals({'P'=>:pdf, 'H'=>:html, 'W'=>:msword, 'T'=>:text},
                Article.file_type_option_symbols) 

By default the first letter of the label is used as the one character value 
in the database field.  When there are duplicate first letters
you can specify a different letter to be stored in the database
In the example below 'R' is stored in the database when
'Credit Card Account' is selected.

Example #1: Selection list

class Article < ActiveRecord::Base
 selection_options_for :payment_method_option,
     [:basic,  'Basic'],
     [:cash,   'Cash Account'],
     [:cc, 'R','Credit Card Account']
end

$ <%=  select :article, :payment_method_option, Article.payment_method_options %> 

Example #2: Radio button labels

$  <% Article.payment_method_option_hash.each do | key, value | %>
$    <%=  radio_button :article, :payment_method_option, key %> <%= value %><br />
$  <% end %>

Example #3 in a java_script list
    payment_method_option_js_list


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
