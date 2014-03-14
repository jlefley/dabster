class Artist < Sequel::Model
  many_to_many :groups

  def validate
    super
    
    if what_id
      validates_presence :what_name
    end
  end
end
