require 'i18n'

module Digget
  # This class is the validator superclass containing the logic to cast
  # the parameters and verify the options that are defined on them
  class Validator
    def initialize(params, object = nil)
      @object = object
      @casted_params = {}
      @errors = []
      @params = params
    end

    # This method returns an array with all the errors during validation
    # @return [Array] An array containing the validation errors
    attr_reader :errors

    # This method returns a hash with the parameters casted to their requested type
    # @return [Hash] A hash with as a key the parameter symbol and the casted value as value
    attr_reader :casted_params

    # This method verifies one of the parameters with the provided options
    # @param name [Symbol] The name of the param in the `params` hash
    # @param type [Class] Type that the parameter should be casted to
    # @param options [Hash] Validation options for this parameter
    def verify(name, type, options = {})
      casted_param = cast(@params[name], type)
      return unless @errors.empty?
      @casted_params[name] = casted_param
      verify_options(casted_param, name, options)
      casted_param
    end

    def filter(name, type, options = {})
      param = verify(name, type, options)
      return object unless @errors.empty?
      filter_options(param, name, options)
    end

    # This method is a helper method to determine whether the validation of the parameters was successful
    # @return `true` if there were no errors during parameter checking, `false` otherwise
    def valid?
      @errors.empty?
    end

    private

    # This method casts the parameter to the requested type if possible
    # @param param [String] Parameter that is about to get casted
    # @param type [Class] The type that the parameter should be after this method
    # @return Returns a casted version of the provided parameter
    def cast(param, type)
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
    def verify_options(param, name, options = {})
      options.each do |key, value|
        if key == :required && value
          next unless param.nil?
          @errors.append(I18n.t('digget.required', name: name))
        elsif key == :min && !param.nil?
          next unless param < value
          @errors.append(I18n.t('digget.min', name: name, value: value))
        elsif key == :max && !param.nil?
          next unless param > value
          @errors.append(I18n.t('digget.max', name: name, value: value))
        elsif key == :equal && !param.nil
          next unless param != value
          @errors.append(I18n.t('digget.equal', name: name, value: value))
        elsif key == :not_equal && !param.nil
          next unless param == value
          @errors.append(I18n.t('digget.not_equal', name: name, value: value))
        elsif key == :min_length && !param.nil?
          next unless param.length < value
          @errors.append(I18n.t('digget.min_length', name: name, value: value))
        elsif key == :max_length && !param.nil?
          next unless param.length > value
          @errors.append(I18n.t('digget.max_length', name: name, value: value))
        elsif key == :length && !param.nil?
          next unless param.length == value
          @errors.append(I18n.t('digget.length', name: name, value: value))
        end
      end
    end

    def filter_options(param, name, options = {})
      name = options.key?(:column) ? options[:column] : name
      return unless @object && options.key?(:filter)
      filter = options[:filter]
      if filter == :min
        @object = @object.where(@object.arel_table[name].gteq(param))
      elsif filter == :max
        @object = @object.where(@object.arel_table[name].lteq(param))
      elsif filter == :equal
        @object = @object.where(@object.arel_table[name].eq(param))
      elsif filter == :not_equal
        @object = @object.where(@object.arel_table[name].not_eq(param))
      end
    end
  end

end