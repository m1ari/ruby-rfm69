class RFM69
  # Register names
  module Registers
    WRITE_MASK      = 0x80  # To write a register OR this with the Register name

    FIFO            = 0x00
    OPMODE          = 0x01
    DATA_MODUL      = 0x02
    BITRATE_MSB     = 0x03
    BITRATE_LSB     = 0x04
    FDEV_MSB        = 0x05
    FDEV_LSB        = 0x06
    FRF_MSB         = 0x07
    FRF_MID         = 0x08
    FRF_LSB         = 0x09
    OSC1            = 0x0A
    AFC_CTRL        = 0x0B
    #               = 0x0C
    LISTEN1         = 0x0D
    LISTEN2         = 0x0E
    LISTEN3         = 0x0F
    VERSION         = 0x10   # Version and serial number
    PA_LEVEL        = 0x11
    PA_RAMP         = 0x12
    OCP             = 0x13
    #               = 0x14
    #               = 0x15
    #               = 0x16
    #               = 0x17
    LNA             = 0x18
    RX_BW           = 0x19
    AFC_BW          = 0x1A
    OOK_PEAK        = 0x1B
    OOK_AVG         = 0x1C
    OOF_FIX         = 0x1D
    AFC_FEI         = 0x1E
    AFC_MSB         = 0x1F
    AFC_LSB         = 0x20
    FEI_MSB         = 0x21
    FEI_LSB         = 0x22
    RSSI_CONFIG     = 0x23
    RSSI_VALUE      = 0x24
    DIO_MAPPING1    = 0x25
    DIO_MAPPING2    = 0x26
    IRQ_FLAGS1      = 0x27
    IRQ_FLAGS2      = 0x28
    RSSI_THRESHOLD  = 0x29
    RX_TIMEOUT1     = 0x2A
    RX_TIMEOUT2     = 0x2B
    PREAMBLE_MSB    = 0x2C
    PREAMBLE_LSB    = 0x2D
    SYNC_CONFIG     = 0x2E
    SYNCVALUE1      = 0x2F
    SYNCVALUE2      = 0x30
    # Sync values 1-8 go here
    PACKET_CONFIG1  = 0x37
    PAYLOAD_LENGTH  = 0x38
    # Node address, broadcast address go here
    AUTOMODES       = 0x3B
    FIFO_THRESHOLD  = 0x3C
    PACKET_CONFIG2  = 0x3D
    # AES Key 1-16 go here
    TEMP1           = 0x4E
    TEMP2           = 0x4F
    #               = 0x50 - 0x57
    TEST_LNA        = 0x58
    #               = 0x59
    TEST_PA1        = 0x5A
    #               = 0x5B
    TEST_PA2        = 0x5C
    #               = 0x5D
    #               = 0x5E
    #               = 0x5F
    #               = 0x60 - 0x6E
    TEST_DAGC       = 0x6F
    #               = 0x70
    TEST_AFC        = 0x71
    #               = 0x72 - 0x7F
  end
end
