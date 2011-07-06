# Rad library i2c
# outdated?

module Rad::Arduino::Sketch::I2cEeprom

  def output_pin_i2c_eeporm(num, opts={})
    two_wire(num, opts) unless @@twowire_inc
    i2c_eeprom(num, opts)
    return # don't use declarations, accessor, signatures below
  end

end