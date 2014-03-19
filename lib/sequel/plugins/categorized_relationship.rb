module Sequel
  module Plugins
    module CategorizedRelationship

      def self.apply(model)
        model.instance_variable_set(:@relationship_reflections, {})
      end

      module ClassMethods
        attr_reader :relationship_reflections

        def categorized_relationship(name, options={})
          rel_class = options.fetch(:relationship_class)
          singular_name = singularize(name)

          join_table = Object.const_get(rel_class).table_name

          rel_name = "#{singular_name}_relationships".to_sym
          many_to_many(name, options.merge(join_table: join_table))
          one_to_many rel_name, class: rel_class, key: association_reflections[name][:left_key]

          adder_name = "_add_#{singular_name}".to_sym
          define_method(adder_name) { |o, attrs| add_categorized_relationship(o, attrs, name) }
          send(:private, adder_name)
          
          remover_name = "_remove_#{singular_name}".to_sym
          define_method(remover_name) { |o, attrs| remove_categorized_relationship(o, attrs, name) }
          send(:private, remover_name)
          
          clearer_name = "_remove_all_#{name}".to_sym
          define_method(clearer_name) { |attrs| remove_all_categorized_relationships(attrs, name) }
          send(:private, clearer_name)
          
          define_method("#{name}_by") { |field, *filter| related_objects(field, name, *filter) }

          relationship_reflections[name] = {
            singular_name: singular_name,
            key: association_reflections[name][:right_key],
            dataset: association_reflections[name].dataset_method,
            relationship_dataset: association_reflections[rel_name].dataset_method
          }
        end
      end

      module InstanceMethods

        private

        def add_categorized_relationship(o, attrs, name)
          ref = relationship_reflections(name)
          send("add_#{ref[:singular_name]}_relationship", stringify_symbols(attrs.merge(ref[:key] => o.id)))
        end

        def remove_categorized_relationship(o, attrs, name)
          ref = relationship_reflections(name)
          rel = send(ref[:relationship_dataset]).where(stringify_symbols(attrs.merge(ref[:key] => o.id))).first
          raise(Sequel::Error, "associated object #{o.inspect} is not currently associated to #{inspect} with #{attrs}") unless rel
          rel.destroy
        end

        def remove_all_categorized_relationships(attrs, name)
          ref = relationship_reflections(name)
          send(ref[:relationship_dataset]).where(stringify_symbols(attrs)).delete
        end

        def relationship_reflections(name)
          self.class.relationship_reflections[name]
        end

        def stringify_symbols(hash)
          Hash[hash.map { |k, v| [k, v.is_a?(Symbol) ? v.to_s : v] }]
        end

        def related_objects(field, name, *filter)
          critera = filter[0] || {}
          ref = relationship_reflections(name)
          mapping = Hash.new { |hash, key| hash[key] = [] }
          relationship_ds = send(ref[:relationship_dataset])
          cats = relationship_ds.select_group(field).map { |r| r.send(field) }
          objects = send(ref[:dataset]).all
          relationship_ds.select_group(field).map { |r| r.send(field) }.each do |cat|
            relationship_ds.where(critera.merge(field => cat)).all.each do |rel|
              mapping[cat.to_sym] << objects.select { |o| o.id == rel.send(ref[:key]) }.first
            end
          end
          mapping
        end

      end

    end
  end
end
