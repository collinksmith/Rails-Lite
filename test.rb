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
      p s
      eval(s)
    else
      s << " = {}"
      p s
      eval(s)
    end
  end
  h
end

p set_hash(['user', 'address', 'street'], 'main')