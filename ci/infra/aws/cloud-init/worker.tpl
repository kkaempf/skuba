#cloud-config

# set locale
locale: en_GB.UTF-8

# set timezone
timezone: Etc/UTC

# flavio, rafa, salt-ssh keys
ssh_authorized_keys:
${authorized_keys}

## need to disable gpg checks because the cloud image has an untrusted repo
#zypper:
#  repos:
#    - id: caasp
#      name: caasp
#      baseurl: ${repo_baseurl}
#      enabled: 1
#      autorefresh: 1
#      gpgcheck: 0
#  config:
#    gpgcheck: "off"
#    solver.onlyRequires: "true"
#    download.use_deltarpm: "true"
#
## need to remove the standard docker packages that are pre-installed on the
## cloud image because they conflict with the kubic- ones that are pulled by
## the kubernetes packages
#packages:
#  - kubernetes-kubeadm
#  - kubernetes-kubelet
#  - kubectl
#  - "-docker"
#  - "-containerd"
#  - "-docker-runc"
#  - "-docker-libnetwork"

# need to resort to that because something is messing up the module
# order and actication on EC2. I've already reached out to Robert
# about that
runcmd:
  - /usr/bin/zypper ar -G ${repo_baseurl} caasp
  - /usr/bin/zypper ref
  - /usr/bin/zypper in -y kubernetes-kubeadm kubernetes-kubelet kubectl cni-plugins -docker -containerd -docker-runc -docker-libnetwork

final_message: "The system is finally up, after $UPTIME seconds"