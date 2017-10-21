[![codecov](https://codecov.io/gh/pielambr/digget/branch/master/graph/badge.svg)](https://codecov.io/gh/pielambr/digget)
[![Build Status](https://travis-ci.org/pielambr/digget.svg?branch=master)](https://travis-ci.org/pielambr/digget)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2351e4afa1f24e16af9c576bc619ea40)](https://www.codacy.com/app/pielambr/digget?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pielambr/digget&amp;utm_campaign=Badge_Grade)
[![Gem Version](https://badge.fury.io/rb/digget.svg)](https://badge.fury.io/rb/digget)
# Digget
This gem aims to make for an easier search API by validating incoming parameters and filtering your model accordingly.

**Note**: this gem is under _very early_ development and is not finished in any way
## Usage
### Validating of parameters
The only thing you have to do is extends the Validator class, so you can use the `verify` method.
```ruby
class YourValidator < Digget::Validator
  def validate_id_params
    verify :id, Integer, max: 100, min: 50
  end
  
  def validate_search_params
      verify :name, String, required: true
      verify :size, Float, required: true, min: 15
    end
end
```
To validate the `params` you need to run the validator;
```ruby
validator = YourValidator.new(params)
validator.validate_id_params
```
You can then see if there are any errors during validation
```ruby
validator.errors
```
You can also get a Hash with the parameters casted to the right datatype;
```ruby
validator.casted_params
```
#### Supported datatypes
- Float
- Integer
- String
- Date
- Time
#### Supported validation options
All of the following options can be combined
- **required** (checks whether the parameter is present)
- **min** (checks whether the parameter is larger than the provided value)
- **max** (checks whether the parameter is lower than the provided value)
- **min_length** (checks whether the parameter is longer than this)
- **max_length** (checks whether the parameter is shorter than this)
- **length** (checks whether the parameter has this exact length)
- **equal** (check whether the parameter is equal to the provided value)
- **not_equal** (checks whether the parameter is not equal to the provided value)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'digget'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install digget
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
