module Rad::Test
  def run
    test_dir = RAD_LIB.join('..','test','hello_world_test')
    puts "Compiling hello_world.cpp to test your Arduino."
    puts "cd #{test_dir}; make depend; make;"
    `cd #{test_dir}; make depend; make;`
    puts
    puts "Compilation successful."
    puts
    puts "Make sure your Arduino is connected and then hit return."
    Readline::readline('')

    `cd #{test_dir}; make upload`

    # find the USB port to make sure the Arduino's actually plugged in
    options, parser = OptionParser.parse(ARGV)
    usb_port = options["hardware"]["serial_port"]
    port_name = usb_port.split("/").last
    port_dir = usb_port.split("/")[0..(usb_port.split("/").length-2)].join("/")
    unless `ls #{port_dir}`.split(/\n/).any?{|d| d.match(/#{port_name}/)}
      puts
      puts "******************************************************"
      puts "*** It looks like your Arduino is not plugged in.  ***"
      puts "***        Plug it in and try again.               ***"
      puts "***                                                ***"
      puts "***   NOTE: If your usb port is not /dev/tty.usb*  ***"
      puts "***  pass it in to this script with the -p option. ***"
      puts "******************************************************"
    else
      puts
      puts "******************************************************"
      puts "***                 Success!                       ***"
      puts "***  If your Arduino's light starts blinking soon, ***"
      puts "***     then your Arduino environment is           ***"
      puts "***          correctly configured.                 ***"
      puts "***                                                ***"
      puts "*** Otherwise something is not hooked up properly. ***"
      puts "******************************************************"
    end
    puts
    puts "cleaning up..."
    `rm #{test_dir}/hello_world.hex #{test_dir}/core.a #{test_dir}/hello_world.elf`
  end
end