class Artist < Sequel::Model
  many_to_many :groups
  many_to_many :library_items, class: 'Library::Item', join_table: :artist_library_item_relationships

  def library_items_dataset
    db[:libdb__items].select_all(:items).
      inner_join(:artist_library_item_relationships, [[:library_item_id, :id], [:artist_id, id]])
  end

  def validate
    super
    
    if what_id
      validates_presence :what_name
    end
  end
end
