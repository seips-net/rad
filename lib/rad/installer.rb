class Rad::Installer
  def self.run

    case $config['os']
    when 'linux'
      Rad::Installer::Linux.run
    when 'mac'
      Rad::Installer::Mac.run
    when 'windows'
      Rad::Installer::Windows.run
    else
      exit
    end
    
  end
end