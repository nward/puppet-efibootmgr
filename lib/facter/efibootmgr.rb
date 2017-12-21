Facter.add(:efibootmgr) do
  setcode do
    efibootmgr_data = Facter::Util::Resolution.exec("/usr/sbin/efibootmgr -v")
    data = {
    }
    efibootmgr_data.each_line do |line|
      case line
      when /^BootCurrent: ([0-9]+)$/
        data['BootCurrent'] = $1
      when /^Timeout: (.*) seconds$/
        data['Timeout'] = $1
      when /^BootOrder: ([0-9A-F,]+)$/
        data['BootOrder'] = $1.split(',')
      when /^Boot([0-9A-F]+)(\*| ) ([^\t]+)\t(.*)$/
        option = {
	  'id' => $1,
          'active' => ($2 == '*'),
          'name' => $3
        }
        if $4 =~ /MAC\(([a-f0-9]{12})/
	  option['mac'] = $1
        end
        
	if ! data.has_key? 'options'
          data['options'] = []
        end

        data['options'].push option
      end
    end
    
    data
  end
end
