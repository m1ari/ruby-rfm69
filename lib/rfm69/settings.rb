class RFM69
  # Register names
  module Values
    module PA # RegPaLevel
      PA0       = 0x80  # Bit  7
      PA1       = 0x40  # Bit  6
      PA2       = 0x20  # Bit  5
      PA_BITS   = PA0 | PA1 | PA2
      PWR_BITS  = 0x1f  # Bits 4-0

    end
  end
end

__END__
    # RegPaRamp
    RF_PARAMP_3400                      0x00
    RF_PARAMP_2000                      0x01
    RF_PARAMP_1000                      0x02
    RF_PARAMP_500                           0x03
    RF_PARAMP_250                           0x04
    RF_PARAMP_125                           0x05
    RF_PARAMP_100                           0x06
    RF_PARAMP_62                            0x07
    RF_PARAMP_50                            0x08
    RF_PARAMP_40                            0x09  // Default
    RF_PARAMP_31                            0x0A
    RF_PARAMP_25                            0x0B
    RF_PARAMP_20                            0x0C
    RF_PARAMP_15                            0x0D
    RF_PARAMP_12                            0x0E
    RF_PARAMP_10                            0x0F

    # RegOcp
    RF_OCP_OFF                              0x0F
    RF_OCP_ON                                 0x1A  // Default

    RF_OCP_TRIM_45                      0x00
    RF_OCP_TRIM_50                      0x01
    RF_OCP_TRIM_55                      0x02
    RF_OCP_TRIM_60                      0x03
    RF_OCP_TRIM_65                      0x04
    RF_OCP_TRIM_70                      0x05
    RF_OCP_TRIM_75                      0x06
    RF_OCP_TRIM_80                      0x07
    RF_OCP_TRIM_85                      0x08
    RF_OCP_TRIM_90                      0x09
    RF_OCP_TRIM_95                      0x0A
    RF_OCP_TRIM_100                     0x0B  // Default
    RF_OCP_TRIM_105                     0x0C
    RF_OCP_TRIM_110                     0x0D
    RF_OCP_TRIM_115                     0x0E
    RF_OCP_TRIM_120                     0x0F


