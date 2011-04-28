# Rad library i2c
# outdated?

module Rad::ArduinoSketch::I2c

  def output_pin_i2c(num, opts={})
    two_wire(num, opts) unless @@twowire_inc
    return # don't use declarations, accessor, signatures below
  end

end