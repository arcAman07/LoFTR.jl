"""
Linear Transformer proposed in "Transformers are RNNs: Fast Autoregressive Transformers with Linear Attention"
Modified from: https://github.com/idiap/fast-
transformers/blob/master/fast_transformers/attention/linear_attention.py.
"""
using Flux
function elu_feature_map(x)
  return elu(x)+1
end

function LinearAttention(queries::AbstractArray, keys::AbstractArray, values::AbstractArray, eps=10^(-6); q_mask::AbstractArray = nothing, kv_mask::AbstractArray = nothing)
  """ Multi-Head linear attention proposed in "Transformers are RNNs"
        Args:
            queries: [N, L, H, D]
            keys: [N, S, H, D]
            values: [N, S, H, D]
            q_mask: [N, L]
            kv_mask: [N, S]
        Returns:
            queried_values: (N, L, H, D)
    """
    Q = elu_feature_map(queries)
    K = elu_feature_map(keys)

     # set padded position to zero
    if (q_mask !== nothing)
      Q = Q* q_mask[:,:,nothing,nothing]
    end
    if (kv_mask !== nothing)
      K = K * kv_mask[:, :, nothing, nothing]
      values = values * kv_mask[:, :, nothing, nothing]
    end
    v_length = values.size(1)
    values = values / v_length  # prevent fp16 overflow

"""
Multi-head scaled dot-product attention, a.k.a full attention.

# Arguments:
  - `queries`: [N, L, H, D]
  -`keys``: [N, S, H, D]
  -`values``: [N, S, H, D]
  -`q_mask``: [N, L]
  -`kv_mask``: [N, S]
Returns:
  queried_values: (N, L, H, D)
"""

function FullAttention(queries::AbstractArray, keys::AbstractArray, values::AbstractArray, q_mask=None, kv_mask=None,use_dropout=False, attention_dropout=0.1)

