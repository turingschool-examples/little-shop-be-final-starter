class ErrorSerializer
  def self.format_errors(messages)
    {
      message: 'Your query could not be completed',
      errors: Array(messages)
    }
  end

  def self.format_validation_errors(record)
    { 
      message: "your query could not be completed", 
      errors: record.errors.full_messages
    }
  end

  def self.format_invalid_search_response
    {
      message: "your query could not be completed",
      errors: ["invalid search params"]
    }
  end
end