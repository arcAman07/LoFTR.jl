function conv1x1(in_planes, out_planes, stride=1)
    """1x1 convolution without padding."""
    return Conv((1,1), in_planes => out_planes, stride=stride, padding=0, bias=False)
end

function conv3x3(in_planes, out_planes, stride=1)
    """3x3 convolution without padding."""
    return Conv((3,3), in_planes => out_planes, stride=stride, padding=0, bias=False)
end

function BasicBlock(in_planes, out_planes,stride=1)
  
