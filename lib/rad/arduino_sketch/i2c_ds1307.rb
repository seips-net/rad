# Rad library i2c
# outdated?

module Rad::ArduinoSketch::I2cDs1307

  def output_pin_i2c_ds1307(num, opts={})
    two_wire(num, opts) unless @@twowire_inc
    ds1307(num, opts)
    return # don't use declarations, accessor, signatures below
  end

end