class efibootmgr (
  Array[Hash] $order,
) {
  if ! has_key($facts, 'efibootmgr') {
    fail ("EFI configuration is not available on this system")
  }
  $order_options = $order.map |$order_option| {
    if $order_option['value'] =~ Undef {
      fail ("order entry [${order_option}] does not have a value set")
    }
    case $order_option['type'] {
      'mac': { efibootmgr::get_option_by_mac($order_option['value'])['id'] }
      'name': { efibootmgr::get_option_by_name($order_option['value'])['id'] }
      default: { fail ("efibootmgr option type of ${order_option['type']}] is not supported") }
    }
  }
  $order_string = join($order_options,',')
  if $facts['efibootmgr']['BootOrder'] != $order_options {
    exec { 'set efi boot order':
      command => "/usr/sbin/efibootmgr -o '${order_string}'",
    }
  }
}

