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
          
          remover_name = "_remove_#{singular_name}".to_sym
          define_method(remover_name) { |o, cat| remove_categorized_relationship(o, cat, name) }
          send(:private, remover_name)
          
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
          ref = relationship_reflections(name)
          send("add_#{ref[:singular_name]}_relationship", ref[:key] => o.id, ref[:category_column] => cat.to_s)
        end

        def remove_categorized_relationship(o, cat, name)
          ref = relationship_reflections(name)
          rel = send("#{ref[:relationship_name]}_dataset").where(ref[:key] => o.id, ref[:category_column] => cat.to_s).first
          raise(Sequel::Error, "associated object #{o.inspect} is not currently associated to #{inspect} as #{cat}") unless rel
          rel.destroy
        end

        def relationship_reflections(name)
          self.class.relationship_reflections[name]
        end

        def related_objects(name)
          ref = relationship_reflections(name)
          mapping = Hash.new { |hash, key| hash[key] = [] }
          relationships = send(ref[:relationship_name])
          objects = load_associated_objects(self.class.association_reflections[name])
          relationships.each do |rel|
            mapping[rel.send(ref[:category_column]).to_sym] << objects.select { |o| o.id == rel.send(ref[:key]) }.first
          end
          mapping
        end

      end

    end
  end
end
