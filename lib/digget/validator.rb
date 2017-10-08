module Digget

  class Validator
    def initialize(params)
      @errors = []
      @casted_params = Hash.new
      @params = params
    end

    # This method verifies one of the parameters with the provided options
    # @param name The name of the param in the `params` hash
    # @param type Type that the parameter should be casted to
    def verify(name, type, *options)
      @casted_params[name] = cast(@params[name], type, options)
    end

    # This method is a helper method to determine whether the validation of the parameters was successful
    # @return `true` if there were no errors during parameter checking, `false` otherwise
    def is_valid?
      @errors.empty?
    end

    # This method returns an array with all the errors during validation
    # @return An array containing the validation errors
    def errors
      @errors
    end

    # This method returns a hash with the parameters casted to their requested type
    # @return A hash with as a key the parameter symbol and the casted value as value
    def casted_params
      @casted_params
    end

    private

    # This method casts the parameter to the requested type if possible
    # @param param Parameter that is about to get casted
    # @param type The type that the parameter should be after this method
    # @return Returns a casted version of the provided parameter
    def cast(param, type, options)
      begin
        return nil                  if param.nil?
        return Integer(param)       if type == Integer
        return String(param)        if type == String
        return Float(param)         if type == Float
        return Date.parse(param)    if type == Date
        return Time.parse(param)    if type == Time
      rescue ArgumentError
        errors.append("The parameter `#{param}` cannot be converted to type `#{type}`")
      end
    end

  end

end