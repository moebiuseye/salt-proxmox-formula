{% from "proxmox/map.jinja" import rawmap with context %}

{% if rawmap.networks is defined %}
interfaces_file:
    file.managed:
        - name: /etc/network/interfaces
        - source: salt://proxmox/files/interfaces.j2
        - template: jinja
        - context:
            networks: {{rawmap.networks}}
{% endif %}

hosts_file:
    file.managed:
        - name: /etc/hosts
        - source: salt://proxmox/files/hosts.j2
        - template: jinja
{% if rawmap.networks is defined %}
        - context:
            networks: {{rawmap.networks}}
{% endif %}

cgroups_fstab_file:
  mount.mounted:
    - name: /sys/fs/cgroup
    - device: none
    - fstype: cgroup
    - opts: defaults
    - mount: False
