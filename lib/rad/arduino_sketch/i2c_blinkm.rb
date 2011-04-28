# Rad library i2c_blinkm
# outdated?

module Rad::ArduinoSketch::I2cBlinkm

  def output_pin_i2c_blinkm(num, opts={})
    two_wire(num, opts) unless @@twowire_inc
    blinkm
    return # don't use declarations, accessor, signatures below
  end

end