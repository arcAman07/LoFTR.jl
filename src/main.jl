using Flux
function elu_feature_map(x)
  return elu(x)+1
end

a = elu_feature_map
print(a(3))