module Onix3
  module Model
    module Helper

      module CodeList
        
        def self.included(klass)
          klass.extend(ClassMethods)
        end

        def set_code_list_value(var, value, list)
          value = CodeFromList.new(value, list) unless value.kind_of? CodeFromList
          instance_variable_set(var, value)
        end

        module ClassMethods
          def attr_from_list(name, list) 
            define_method "#{name}=" do |value|
              set_code_list_value(name, value, list)
            end
            define_method name do
              instance_variable_get name
            end
          end
        end
        
      end

    end
  end
end
