# SelectionOptionsFor
# Copyright (c) 2005 Mark Windholtz (www.railsstudio.com)
#

module RailsStudio # :nodoc:
  module SelectionOptionsFor # :nodoc:
    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def selection_options_for(id, *opts)  # :nodoc:
        id = id.to_s
        id_hash = id + '_hash'
        class_eval <<-EOF
          write_inheritable_attribute("#{id_hash}".to_sym, {})
          def self.#{id_hash}()
            read_inheritable_attribute("#{id_hash}".to_sym)
          end
          def self.#{id}s   
            #{id_hash}.map { |key, value| [value,key] }.sort
          end
          def #{id}_label
            #{self}.#{id_hash}[#{id}]
          end
          def self.#{id}_js_list
            result = '['
            #{id_hash}.values.each{ |e| result = result + "'"+ e + "', "}
            result.chop!.chop! if result.size > 2
            result + ']'
          end
          
        EOF
        # load the labels into the class id_hash variable
        opts.each do |label|
          unless label.class == Array
            raise "Invalid item ["+ label.to_s + "] in :" + id + " of type [" + label.class.to_s + "]. Expected Array"
          end          
          case label.size
          when 2
            letter, display_text = label[1].first,  label[1]
          when 3
            letter, display_text = label[1], label[2]
          else
            raise "Invalid number of items in selection_options_for :" + id + " ["   +
                   label.class.to_s + "]."
          end
          if(send(id_hash).has_key?(letter))
            raise "Duplicate key during selection_options_for :" + id + ".  key: " + 
                   letter + ' for text: ' + display_text
          end
          send(id_hash)[letter] = display_text
          module_eval <<-EOF2
            def #{id}_#{label[0].to_s}?
              self.#{id} == '#{letter}'
            end
            def #{id}_#{label[0].to_s}!
              self.#{id} = '#{letter}'
            end
          EOF2
        end # opts.each
      end # ClassMethods
    end # selection_options_for
  end # Module SelectionOptionsFor
end # Module RailsStudio

ActiveRecord::Base.class_eval do
  include RailsStudio::SelectionOptionsFor
end
