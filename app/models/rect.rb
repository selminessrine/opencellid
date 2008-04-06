class Rect
  @minLat
  @minLon
  @maxLat
  @maxLon
  def initialize minLon,minLat,maxLon,maxLat
    @minLat=minLat
    @minLon=minLon
    @maxLat=maxLat
    @maxLon=maxLon
  end
  def minLat
    return @minLat
  end
  def minLon
    return @minLon
  end
  def maxLat
    return @maxLat
  end
  def maxLon
    return @maxLon
  end
end
