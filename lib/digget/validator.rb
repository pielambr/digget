require 'i18n'

module Digget
  # This class is the validator superclass containing the logic to cast
  # the parameters and verify the options that are defined on them
  class Validator
    def initialize(params)
      @errors = []
      @casted_params = Hash.new
      @params = params
    end

    # This method verifies one of the parameters with the provided options
    # @param name [Symbol] The name of the param in the `params` hash
    # @param type [Class] Type that the parameter should be casted to
    # @param options [Hash] Validation options for this parameter
    def verify(name, type, *options)
      casted_param = cast(@params[name], type, options)
      @casted_params[name] = casted_param
      verify_options(casted_param, name, options)
    end

    # This method is a helper method to determine whether the validation of the parameters was successful
    # @return `true` if there were no errors during parameter checking, `false` otherwise
    def valid?
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
    # @param param [String] Parameter that is about to get casted
    # @param type [Class] The type that the parameter should be after this method
    # @return Returns a casted version of the provided parameter
    def cast(param, type, options)
      if param.nil?
        return nil
      elsif type == Integer
        return Integer(param)
      elsif type == String
        return String(param)
      elsif type == Float
        return Float(param)
      elsif type == Date
        return Date.parse(param)
      elsif type == Time
        return Time.parse(param)
      end
    rescue ArgumentError
      errors.append(I18n.t('digget.cast', param: param, type: type))
    end

    # This method verifies the parameters and adds errors when a parameter
    # doesn't conform with the provided verification options
    # @param param The parameter value that needs to be verified
    # @param name [String] The name of the parameter, used to be displayed in error messages
    # @param options [Hash] The verification options for the provided parameter
    def verify_options(param, name, *options)
      options.each do |key, value|
        if key == :required && value
          return unless param.nil?
          @errors.append(I18n.t('digget.required', name: name))
        elsif key == :min && !param.nil?
          return unless param < value
          @errors.append(I18n.t('digget.min', name: name, value: value))
        elsif key == :max && !param.nil?
          return unless param > value
          @errors.append(I18n.t('digget.max', name: name, value: value))
        elsif key == :min_length && !param.nil?
          return unless param.length < value
          @errors.append(I18n.t('digget.min_length', name: name, value: value))
        elsif key == :max_length && !param.nil?
          return unless param.length > value
          @errors.append(I18n.t('digget.max_length', name: name, value: value))
        elsif key == :length && !param.nil?
          return unless param.length == value
          @errors.append(I18n.t('digget.length', name: name, value: value))
        end
      end
    end

  end

end