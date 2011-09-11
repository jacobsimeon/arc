class String
  def to_pascal
    split(/_/).map { |string| string.capitalize }.join
  end
end