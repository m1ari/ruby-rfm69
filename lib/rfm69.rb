require 'rfm69/version'
require 'rfm69/registers'
require 'spi'

class RFM69
  class RFM69Exception < Exception; end
  class RFM69BadValue < RFM69Exception; end

  attr_reader :spi

  FXOSC=32e6         # Crystal oscillator frequency (Datasheet P12)
  FSTEP=FXOSC/2**19  # The Datasheet uses 61.0, it's really got more decimal places and that makes a difference

  def initialize(args={})
    raise RFM69Exception, "You need to specify the device" if args[:device].nil?

    @spi=SPI.new(device: args[:device])

    @spi.speed=500000
    @frequency=frequency
    @bitrate=bitrate
    @deviation=deviation
    #@mode=0
    #@power=0
  end

  ## FREQUENCY
  def frequency
    regs=@spi.xfer(txdata: [Registers::FRF_MSB, 0,0,0])
    @frequency=(regs[1]<<16 | regs[2]<<8 | regs[3]) * FSTEP
  end

  # For 869.5MHz we should get 0xD96012 for Registers 07, 08, 09
    # 290 -> 340 (315MHz Module)
    # 424 -> 510 (434MHz Module)
    # 862 -> 890 (868MHz Module)
    # 890 -> 1020 (915MHz Module)
  def frequency=(freq)
    raise RFM69BadVaue, "Frequency Out of Range" unless freq.between?(290e6,340e6) or freq.between?(424e6,510e6) or freq.between?(862e6,1020e6)

    # Determine the value to put in the registers
    freg = (freq / FSTEP).round

    # Split into seperate bytes
    msb=(freg>>16 & 0xff)
    mid=(freg>>8  & 0xff)
    lsb=(freg     & 0xff)

    puts "Setting frequency #{freq} [#{msb.to_s(16)}, #{mid.to_s(16)}, #{lsb.to_s(16)}]"
    @spi.xfer(txdata: [Registers::FRF_MSB | Registers::WRITE_MASK, msb, mid, lsb])

    @frequency=freq
  end


  ## BitRate
  def bitrate
    regs=@spi.xfer(txdata: [Registers::BITRATE_MSB, 0,0])
    @bitrate=FXOSC / (regs[1]<<8 | regs[2])
  end
  def bitrate=(bitrate)
    br = (FXOSC / bitrate).round
    @spi.xfer(txdata: [Registers::BITRATE_MSB | Registers::WRITE_MASK, (br>>8 & 0xff)])[1]
    @spi.xfer(txdata: [Registers::BITRATE_LSB | Registers::WRITE_MASK, (br    & 0xff)])[1]
    #puts "Writing #{(br>>8 & 0xff).to_s(16)} to #{(Registers::BITRATE_MSB | Registers::WRITE_MASK).to_s(16)}"
    #puts "Writing #{(br    & 0xff).to_s(16)} to #{(Registers::BITRATE_LSB | Registers::WRITE_MASK).to_s(16)}"
  end

  ## Deviation
  def deviation
    regs=@spi.xfer(txdata: [Registers::FDEV_MSB, 0,0])
    @deviation=(regs[1]<<8 | regs[2]) * FSTEP
  end
  def deviation=(deviation)
    fdev = (deviation / FSTEP).round
    #puts "Writing #{(fdev>>8 & 0xff).to_s(16)} to #{(Registers::FDEV_MSB | Registers::WRITE_MASK).to_s(16)}"
    #puts "Writing #{(fdev    & 0xff).to_s(16)} to #{(Registers::FDEV_LSB | Registers::WRITE_MASK).to_s(16)}"
    @spi.xfer(txdata: [Registers::FDEV_MSB | Registers::WRITE_MASK, (fdev>>8 & 0xff)])[1]
    @spi.xfer(txdata: [Registers::FDEV_LSB | Registers::WRITE_MASK, (fdev    & 0xff)])[1]
  end

  def mode
  end
  def mode=(mode)
  end

  def power
  end
  def power=(power)
    raise RFM69BadVaue, "Power level of #{power} is outside allowed range" unless power.between?(-18,20)
    # -18 -> +13dBm for RFM69 PA0 only
    # -18 -> +20dBm for RFM69H

    # RFM69H
    # Pa0 Pa1 Pa2
    # 1   0   0     RFM69 -18 -> +13    
    # 0   1   0     RFM69H -2 -> 13
    # 0   1   1     RFM69H +2 -> +17
    # 0   1   1     RFM69H +5 -> +20 
  end

  def version
    value=@spi.xfer(txdata: [Registers::VERSION, 0])[1]
    puts "Version String provides 0x#{value.to_s(16)}"
    raise RFM69Exception, "Bad RFM69 Version number" unless (0x24 == value)
    value
  end

  def temperature
  end

  def read(register)
  end

  def write(register, value)
  end

  
end
