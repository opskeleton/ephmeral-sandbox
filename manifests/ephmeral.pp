node default {
  include apt
  include shell

  if($::lsbdistcodename == 'vivid'){
    Service {
      provider => 'systemd'
    }
  }
  class{'vpnize::torguard':}
  class{'vpnize::fortint':}
  class{'vpnize::openconnect':}
}
