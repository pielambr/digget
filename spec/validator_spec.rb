require 'spec_helper'

module Digget
  describe Validator do

    class IntegerValidator < Validator
      def validate
        verify :id, Integer
      end
    end

    before(:each) do
      @validator = IntegerValidator.new({ id: '3' })
      @validator.validate
    end

    it 'tests if a validator starts out with no errors' do
      expect(@validator.errors).to be_empty
    end

    it 'tests whether an integer gets correctly casted out of the params' do
      expect(@validator.casted_params[:id]).to eq(3)
    end

    it 'tests whether a cast error results in a translated error being saved' do
      validator = IntegerValidator.new(id: 'abc')
      validator.validate
      expect(validator.errors.length).to eq(1)
      expect(validator.valid?).to eq(false)
    end
  end
end
