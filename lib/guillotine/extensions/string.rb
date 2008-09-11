class String
  include Indexable
  
  def to_sql
    self
  end
end
