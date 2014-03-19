class Artist < Sequel::Model
  many_to_many :groups

  def validate
    super
    
    if what_id
      validates_presence :what_name
      validates_presence :what_updated_at
    end
  end
end
