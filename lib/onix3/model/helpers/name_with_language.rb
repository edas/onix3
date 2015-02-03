module Onix3
  module Model
    module Helper
      module NameWithLanguage

        def self.included(klass)
          klass.extend(ClassMethods)
        end

        def set_name_with_language(var, name, language=nil)
          name = NameWithLanguage.new(name, language) unless name.kind_of? NameWithLanguage
          instance_variable_set(var, name)
        end

        module ClassMethods
          def attr_with_language(name) 
            define_method "#{name}=" do |value|
              set_name_with_language(name, value)
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
end
