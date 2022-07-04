function conv1x1(in_planes, out_planes, stride=1)
  return Conv((1,1), in_planes => out_planes, stride=stride, padding=0, bias=False)
    # """1x1 convolution without padding."""
end

function conv3x3(in_planes, out_planes, stride=1)
  return Conv((3,3), in_planes => out_planes, stride=stride, padding=0, bias=False)
    # """3x3 convolution without padding."""
end

function BasicBlock(in_planes, out_planes,stride=1,x)
  conv1 = conv3x3(in_planes, out_planes, stride)
  conv2 = conv3x3(out_planes,out_planes,stride)
  bn1 = BatchNorm(out_planes)
  bn2 = BatchNorm(out_planes)
  y = x
  if (stride == 1)
    downsample = None
  else
    downsample = Chain(
      conv1x1(in_planes, out_planes, stride),
      BatchNorm(out_planes)
    )
  end
  y = relu(bn1(conv1(y)))
  y = bn2(conv2(y))
  if (downsample != None)
    x = downsample(x)
  end
  return relu(x+y)
end

function _make_layer(in_planes, dim, stride=1)
  layer1 = BasicBlock(in_planes, dim, stride)
  layer2 = BasicBlock(dim, dim, stride)
  return Chain(
    layer1,
    layer2,
  ),dim
end

# """ResNet+FPN, output resolution are 1/8 and 1/2.
#     Each block has 2 layers.
#     """

function ResNetFPN_8_2(config, x)
  # Config
  inital_dim = config["inital_dim"]
  block_dims = config["block_dims"]
  # Class Variable
  in_planes = inital_dim
  # Networks
  conv1 = Conv((7,7), 1 => inital_dim, stride=2, padding=3, bias=False)
  bn1 = BatchNorm(initial_dim,relu)
  layer1,out_planes = _make_layer(in_planes, block_dims[0], stride=1) # 1/2
  layer2,out1_planes = _make_layer(out_planes, block_dims[1], stride=2) # 1/4
  layer3,_ = _make_layer(out1_planes, block_dims[2], stride=2) # 1/8
   # 3. FPN upsample
   layer3_outconv = conv1x1(block_dims[2], block_dims[2])
   layer2_outconv = conv1x1(block_dims[1], block_dims[2])
   layer2_outconv2 = Chain(
    conv3x3(block_dims[2], block_dims[2]),
    BatchNorm(block_dims[2],leakyrelu),
    conv3x3(block_dims[2], block_dims[1]),
   )
   layer1_outconv = conv1x1(block_dims[0], block_dims[1])
   layer1_outconv2 = Chain(
    conv3x3(block_dims[1], block_dims[1]),
    BatchNorm(block_dims[1],leakyrelu),
    conv3x3(block_dims[1], block_dims[0]),
   )
   x0 = bn1(conv1(x))
   x1 = layer1(x0) # 1/2
   x2 = layer2(x1) # 1/4
   x3 = layer3(x2) # 1/8

   # FPN
   x3_out = layer3_outconv(x3)
   x2_out = layer2_outconv(x2)



  #  # FPN
  #       x3_out = self.layer3_outconv(x3)

  #       x2_out = self.layer2_outconv(x2)
  #       x3_out_2x = F.interpolate(x3_out, size=(x2_out.shape[2:]), mode='bilinear', align_corners=True)
  #       x2_out = self.layer2_outconv2(x2_out + x3_out_2x)

  #       x1_out = self.layer1_outconv(x1)
  #       x2_out_2x = F.interpolate(x2_out, size=(x1_out.shape[2:]), mode='bilinear', align_corners=True)
  #       x1_out = self.layer1_outconv2(x1_out + x2_out_2x)

  #       return [x3_out, x1_out]


  
