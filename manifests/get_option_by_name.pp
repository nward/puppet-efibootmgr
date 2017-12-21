function efibootmgr::get_option_by_name(String $name) >> Hash {
  $facts['efibootmgr']['options'].each |$option| {
    if $option['name'] == $name {
      return $option
    }
  }
  fail("Could not find EFI boot option with name [${name}]")
}
