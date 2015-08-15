node default {
  include apt

  if($::lsbdistcodename == 'vivid'){
    Service {
      provider => 'systemd'
    }
  }

  class {'desktop::x2go':
    server => true,
    port   => '22',
    lan    => '10.0.2.2'
  }
}
