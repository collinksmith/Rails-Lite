require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      parse_www_encoded_form(req.query_string) unless req.query_string.nil?
      parse_www_encoded_form(req.body) unless req.body.nil?

      @params.merge!(route_params)

      p @params

      @params
    end

    def [](key)
      @params[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      key_value_pairs = URI.decode_www_form(www_encoded_form)

      key_value_pairs.each do |pair|
        keys = parse_key(pair.first)
        value = pair.last

        h = set_hash(keys, value)
        p h
        @params.merge!(h)
      end
    end

  def set_hash(keys, value)
    hash = {}
    keys.map!(&:to_s)

    keys.length.times do |i|
      eval_string = "hash"
      (0..i).each do |j|
        eval_string << "['#{keys[j]}']"
      end

      if i == (keys.length - 1)
        eval_string << " = value"
        eval(eval_string)
      else
        eval_string << " = {}"
        eval(eval_string)
      end
    end

    hash
  end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
