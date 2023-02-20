set -x
set -e
name="$(basename $0)"
log(){
  # shellcheck disable=SC2034
  message="$2"
  # shellcheck disable=SC2016
  curl -X POST --header 'Content-Type:application/json' --data "{\"name\":\"${name}\",\"description\":\"${message}\"}" http://192.168.3.190:8080/log/
}
(
  set -x
  set -e
  log "task starting"
  sed -i -e 's/#PubkeyAuthentication/PubkeyAuthentication/' /etc/ssh/sshd_config
#  log "create user: vagrant"
#  echo 'vagrant' | adduser --shell /bin/bash --gecos '' vagrant
#  echo 'vagrant:password' | chpasswd
#  echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/target/etc/sudoers.d/vagrant
#  mkdir -p /home/vagrant/.ssh
#  chown -R vagrant:vagrant /home/vagrant
#  log "create user: vagrant (done)"
  log "create user: samcaldwell"
  echo 'Password01' | adduser --ingroup sudo --shell /bin/bash --gecos '' samcaldwell
  echo 'samcaldwell:Password01' | chpasswd -e
  echo 'samcaldwell ALL=(ALL) NOPASSWD:ALL' >/target/etc/sudoers.d/samcaldwell
  mkdir -p /home/samcaldwell/.ssh
  chown -R samcaldwell:users /home/samcaldwell
  echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/vlGOpc5AzTtBFrmS3ZHpEQDi8ZxlauOWF1dkhgmohyk9sceV8IdBw0Px+eKz9HvbniNPrKXGschvLKiuXVGF17CAJjwFKTC1tlnjSbKnsgI7VKvsFEl5bDv72qT0ZHZRFoDSrdmiqsCH2PYG4OfqA8IEYD0F41ublRWaCGFleZto7G1ssULhFgOMbgUSNWNL9UaOO6vCNKx+5mkBaClUWpiz84GjXOaGh1rAsWgQf+oOPhAjJrL+eyQWo5isQEItrqvC+cNDgMvE0DkK3JQYccVnDa8IMtO65DGJkU0i6yCRiPKmwkbMLYW9UEwY0dhiPxku7jdchPcxdBhhoOSF' >/home/samcaldwell/.ssh/authorized_keys
  log "create user: samcaldwell (done)"
  systemctl enable ssh || exit 1
  export IP_ADDR="$(ifconfig | grep inet | awk '{print $2}' | head -n1)"
  log "Host IP: ${IP_ADDR}"
  log "task completed"
) || log "task failed"
shutdown -r now