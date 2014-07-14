  ## profiles
  include docker

  ## resource defaults
  Docker::Run {
    use_name => true,
    require  => Class['docker'],
  }

  ## resources

  # data-only container
  # stores mariadb
  # does not need to be running
  docker::run { 'db_data':
    image           => 'tutum/ubuntu-trusty',
    command         => '/bin/sh -c "echo docker db_data container came online"',
    volumes         => '/var/lib/mysql',
    restart_service => false,
  } ->


  # mariadb container
  # mounts /data from data container
  docker::run { 'gestio_db':
    image           => 'tutum/mariadb',
    volumes_from    => 'db_data',
    ports           => ['3306:3306'],
  } ->

  # web container
  # pulls from internal registry
  # links redis port from redis container
  # sets host to serve app on port 80
  docker::run { 'gestio_web':
    image           => 'curator/docker-gestioip',
    links           => ['gestio_db:gestio_db'],
    ports           => ['80:80'],
  }
