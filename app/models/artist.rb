class Artist < Sequel::Model
  many_to_many :groups
  many_to_many :library_items, class: 'Library::Item'

  def validate
    super
    
    if what_id
      validates_presence :what_name
    end
  end
end
