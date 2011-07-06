# Arduino standard library servo
# http://arduino.cc/en/Reference/Servo

module Rad::Arduino::Sketch::Servo

  def initialize #:nodoc:
    @servo_settings = []
    @servo_pins = []
    super
  end

  def output_pin_servo(num, opts={})
    servo_setup(num, opts)
    return # don't use declarations, accessor, signatures below
  end

end
