class Artist < Sequel::Model
  many_to_many :groups
  many_to_many :library_items, class: 'Library::Item', join_table: :artists_library_items

  def library_items_dataset
    db[:libdb__items].select_all(:items).inner_join(:artists_library_items, [[:library_item_id, :id], [:artist_id, id]])
  end

  def validate
    super
    
    if what_id
      validates_presence :what_name
    end
  end
end
