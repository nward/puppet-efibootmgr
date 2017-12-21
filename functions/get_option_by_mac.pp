function efibootmgr::get_option_by_mac(String $mac) >> Hash {
  $efi_mac = regsubst(downcase($mac), '[^a-f0-9]', '', 'G')
  $facts['efibootmgr']['options'].each |$option| {
    if ! has_key($option, 'mac') {
      next()
    }
    if $option['mac'] == $efi_mac {
       return $option
    }
  }
  fail("Could not find EFI boot option with mac [${mac}/${efi_mac}]")
}
