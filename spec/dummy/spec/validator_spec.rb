require 'spec_helper'

module Digget
  describe Validator do

    class IntegerValidator < Validator
      def validate
        verify :id, Integer, max: 100, min: 50
      end
    end

    class StringValidator < Validator
      def validate
        filter :id, String, filter: :equal, column: :some_text
      end
    end

    before(:each) do
      @validator = IntegerValidator.new(id: '75')
      @validator.validate
    end

    it 'tests if a validator starts out with no errors' do
      expect(@validator.errors).to be_empty
    end

    it 'tests whether an integer gets correctly casted out of the params' do
      expect(@validator.casted_params[:id]).to eq(75)
    end

    it 'tests whether a cast error results in a translated error being saved' do
      validator = IntegerValidator.new(id: 'abc')
      validator.validate
      expect(validator.errors.length).to eq(1)
      expect(validator.valid?).to eq(false)
    end

    it 'tests the max validation' do
      validator = IntegerValidator.new(id: 123)
      validator.validate
      expect(validator.errors.length).to eq(1)
      expect(validator.valid?).to eq(false)
    end

    it 'tests the min validation' do
      validator = IntegerValidator.new(id: 49)
      validator.validate
      expect(validator.errors.length).to eq(1)
      expect(validator.valid?).to eq(false)
    end

    it 'tests a filter for a matching string' do
      Fluff.create(some_text: 'dummy_text')
      validator = StringValidator.new({ id: 'dummy_text' }, Fluff)
      result = validator.validate
      expect(result.size).to eq(1)
    end

    it 'tests a filter for a not maching string' do
      Fluff.create(some_text: 'not_dummy_text')
      validator = StringValidator.new({ id: 'dummy_text' }, Fluff)
      result = validator.validate
      expect(result.size).to eq(0)
    end
  end
end
