class ErrorSerializer
  def self.format_errors(messages)
    {
      message: 'Your query could not be completed',
      errors: messages
    }
  end

  def self.format_invalid_search_response
    { 
      message: "your query could not be completed", 
      errors: ["invalid search params"] 
    }
  end

  def self.format_record_not_found(model)
    {
      message: 'Your query could not be completed',
      errors: ["#{model} not found"]
    }
  end
end