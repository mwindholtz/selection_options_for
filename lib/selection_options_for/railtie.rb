module SelectionOptionsFor  
  class Railtie < Rails::Railtie
    initializer "selection_options_for.model_additions" do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end    
    end # initializer  
  end # class 
end # module
