def set_hash(keys, value)
  h = {}

  keys.map!(&:to_sym)

  keys.length.times do |i|
    s = "h"
    (0..i).each do |j|
      s << "['#{keys[j]}']"
    end

    if i == (keys.length - 1)
      s << " = value"
      eval(s)
    else
      s << " = {}"
      eval(s)
    end
  end
  h
end

h = set_hash(['user', 'address', 'street'], 'main')

class Hash
  def deep_merge(second)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      self.merge(second, &merger)
  end
end

h = h.deep_merge({'user' => { 'address' => { 'number' => 1357 }}})

p h