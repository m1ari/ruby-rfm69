require 'rfm69/version'
require 'rfm69/registers'
require 'rfm69/settings'
require 'spi'

# TODOs
# We might want to break this down into more managable files
# Convert the setters into functions wth optional argunments so we can make setup more dsl like ?

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
    @power=power
  end

  # The standard form in most of the setter routines is:
  #   1. Check permitted ranges and raise an exception if out of range
  #   2. Convert the human readable value into a value suitable for the RFM69 (based on datasheet)
  #   3. Split that value into seperate bytes
  #   4. Send the values over SPI.
  #   5. Update the instance variable (do we need to keep these)

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
    msb=(br>>8  & 0xff)
    lsb=(br     & 0xff)
    puts "Setting Bitrate #{bitrate} [#{msb.to_s(16)}, #{lsb.to_s(16)}]"
    @spi.xfer(txdata: [Registers::BITRATE_MSB | Registers::WRITE_MASK, msb, lsb])
    @bitrate=bitrate
  end

  ## Deviation
  def deviation
    regs=@spi.xfer(txdata: [Registers::FDEV_MSB, 0,0])
    @deviation=(regs[1]<<8 | regs[2]) * FSTEP
  end
  def deviation=(deviation)
    fdev = (deviation / FSTEP).round
    msb=(fdev>>8  & 0xff)
    lsb=(fdev     & 0xff)
    puts "Setting Frequency Deviation #{deviation} [#{msb.to_s(16)}, #{lsb.to_s(16)}]"
    @spi.xfer(txdata: [Registers::FDEV_MSB | Registers::WRITE_MASK, msb, lsb])
    @deviation=deviation
  end

  # MODE
  def mode
=begin
void rfm69::setMode(uint8_t mode){
  write(RFM69_REG_01_OPMODE, (read(RFM69_REG_01_OPMODE) & 0xE3) | mode);
  _mode=mode;

  if (mode == RFM69_MODE_TX){
    while(!(read(RFM69_REG_27_IRQ_FLAGS1) & RF_IRQFLAGS1_TXREADY)) { };
  }
}
=end
  end
  def mode=(mode)
  end

  def power
    pa_level=@spi.xfer(txdata: [Registers::PA_LEVEL, 0])[1]
    case (pa_level & Values::PA::PA_BITS)
    when Values::PA::PA0
      @power=-18 + (pa_level & Values::PA::PWR_BITS)
    when Values::PA::PA1
      @power=-18 + (pa_level & Values::PA::PWR_BITS)
    when Values::PA::PA1 | Values::PA::PA2
      # TODO Test for HighPower Mode
      @power=-14 + (pa_level & Values::PA::PWR_BITS)
    else
      @power=nil
      raise RFM69BadVaue, "PA_LEVEL Registered returned 0x#{pa_level.to_s(16)} which is not valid"
    end
    @power
  end
  def power=(power)
    raise RFM69BadVaue, "Power level of #{power} is outside allowed range" unless power.between?(-18,20)
    # TODO Set other required Registers
    case power
    when -18..13      # PA0 (RFM69 / RFM69H)
      # PA0
      pa_level=Values::PA::PA0 | power + 18
    when -2..13       # PA1 (RFM69H)
      pa_level=Values::PA::PA1 | power + 18
    when 2..17        # PA1 + PA2 (RFM69H)
      pa_level=Values::PA::PA1 | Values::PA::PA2 | power + 14
    when 5..20        # PA1 + PA2 + High power (RFM69H)
      raise RFM69BadValue, "High power mode not currently supported"
      #pa_level=Values::PA::PA1 | Values::PA::PA2 | power + 11
    else
      raise RFM69BadVaue, "Power level of #{power} is outside allowed range"
    end
    puts "Setting power level of #{power}: pa_level=0x#{pa_level.to_s(16)}"

    @spi.xfer(txdata: [Registers::PA_LEVEL | Registers::WRITE_MASK, pa_level])
    @power=power
  end

  def version
    value=@spi.xfer(txdata: [Registers::VERSION, 0])[1]
    puts "Version String provides 0x#{value.to_s(16)}"
    raise RFM69Exception, "Bad RFM69 Version number" unless (0x24 == value)
    value
  end

  def temperature
=begin
float rfm69::readTemp() {
  // Set mode into Standby (required for temperature measurement)
  uint8_t oldMode = _mode;
  setMode(RFM69_MODE_STDBY);

  // Trigger Temperature Measurement
  write(RFM69_REG_4E_TEMP1, RF_TEMP1_MEAS_START);

  // Wait for reading to be ready
  while (read(RFM69_REG_4E_TEMP1) & RF_TEMP1_MEAS_RUNNING);

  // Read raw ADC value
  uint8_t rawTemp = read(RFM69_REG_4F_TEMP2);

  // Set transceiver back to original mode
  setMode(oldMode);

  // Return processed temperature value
  //return 168.3-float(rawTemp);
  return float(rawTemp) - 90.0;
}
=end
  end

  def read(register)
  end

  def write(register, value)
  end

  
end
