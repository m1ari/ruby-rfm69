require "rfm69/version"
require "rfm69/registers"

class RFM69
  attr_reader :frequency
  attr_reader :mode
  attr_reader :power

  def initalize(args={})
    @frequency
    @mode
    @power
  end

  def frequency=(freq)
    
  end

  def mode=(mode)
  end

  def power=(power)
  end
  # getVer

  def temperature
  end

  def read(register)
  end
  def write(register, value)
  end

  
end
