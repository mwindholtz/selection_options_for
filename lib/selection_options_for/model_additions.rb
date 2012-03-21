module ModelAdditions

  def selection_options_for(id, *opts)  # :nodoc:
    id = id.to_s
    id_hash = id + '_hash'
    id_symbols = id + '_symbols'
    class_eval <<-EOF
      class_attribute "#{id_hash}".to_sym
      send("#{id_hash}=".to_sym, {})
      
      class_attribute "#{id_symbols}".to_sym
      send("#{id_symbols}=".to_sym, {})             
      
      def self.#{id}s   
        #{id_hash}.map { |key, value| [value,key] }.sort
      end
      def #{id}_label
        #{self}.#{id_hash}[#{id}]
      end
      def self.#{id}_js_list
        result = '['
        #{id_hash}.values.sort.each{ |e| result = result + "'"+ e + "', "}
        result.chop!.chop! if result.size > 2
        result + ']'
      end
      def #{id}_symbol
        #{self}.#{id_symbols}[self.#{id}]
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
      send(id_symbols)[letter] = label[0]
      module_eval <<-EOF2
        def #{id}_#{label[0].to_s}?
          self.#{id} == '#{letter}'
        end
        def #{id}_#{label[0].to_s}!
          self.#{id} = '#{letter}'
        end
      EOF2
    end # opts.each
  end # selection_options_for
end 
