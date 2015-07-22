$params = {}
def set_hash(keys, value)
  params = {}
  current = params

  keys.each_with_index do |key, index|
    if index == keys.length - 1
      current[key] = value
    else
      current[key] ||= {}
    end
    current = current[key]
  end

  params
end

h1 = set_hash(['user', 'address', 'street'], 'main')
h2 = set_hash(['user', 'address', 'number'], 1357)

p h1
p h2

p h1.deep_merge(h2)