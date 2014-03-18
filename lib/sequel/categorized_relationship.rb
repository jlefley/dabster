module Sequel
  module Plugins
    module CategorizedRelationship

      def self.apply(model)
        model.instance_variable_set(:@relationship_reflections, {})
      end

      module ClassMethods
        attr_reader :relationship_reflections

        def categorized_relationship(name, column, options={})
          rel_class = options.fetch(:relationship_class)
          singular_name = singularize(name)

          join_table = Object.const_get(rel_class).table_name

          rel_name = "#{singular_name}_relationships".to_sym
          many_to_many(name, options.merge(join_table: join_table))
          one_to_many rel_name, class: rel_class, key: association_reflections[name][:left_key]

          adder_name = "_add_#{singular_name}".to_sym
          define_method(adder_name) { |o, cat| add_categorized_relationship(o, cat, name) }
          send(:private, adder_name)
          
          define_method(name) { related_objects(name) }

          relationship_reflections[name] = {
            singular_name: singular_name,
            key: association_reflections[name][:right_key],
            relationship_name: rel_name,
            category_column: column
          }
        end
      end

      module InstanceMethods

        private

        def add_categorized_relationship(o, cat, name)
          reflection = relationship_reflections(name)
          send("add_#{reflection[:singular_name]}_relationship".to_sym,
               reflection[:key] => o.id, reflection[:category_column] => cat.to_s)
        end

        def relationship_reflections(name)
          self.class.relationship_reflections[name]
        end

        def related_objects(name)
          reflection = relationship_reflections(name)
          mapping = Hash.new { |hash, key| hash[key] = [] }
          relationships = send(reflection[:relationship_name])
          objects = load_associated_objects(self.class.association_reflections[name])
          key = reflection[:key]
          relationships.each do |rel|
            mapping[rel.send(reflection[:category_column]).to_sym] << objects.select { |o| o.id == rel.send(key) }.first
          end
          mapping
        end

      end

    end
  end
end
