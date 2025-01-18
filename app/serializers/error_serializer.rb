class ErrorSerializer
  def self.format_errors(messages)
    {
      message: "Your query could not be completed",
      errors: messages
    }
  end

  def self.format_invalid_search_response
    { 
      message: "Coupon not found", 
      errors: ["Invalid search parameters provided"] 
    }
  end

  def self.format_validation_errors(coupon)
    {
      message: "Coupon could not be created",
      errors: coupon.errors.full_messages
    }
  end

end