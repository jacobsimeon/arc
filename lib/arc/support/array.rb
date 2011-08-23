class Array
  def symbolize_keys!
    map do |item|
      item.symbolize_keys! if item.respond_to? :symbolize_keys!
    end    
  end 
end