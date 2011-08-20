class Hash
  def symbolize_keys!
    keys.each do |key|
      value = delete key
      if value.is_a? Hash
        value.symbolize_keys!
      end
      self[(key.to_sym rescue key) || key] = value
    end
    self
  end
end