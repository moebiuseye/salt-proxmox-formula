{% from "proxmox/map.inja" import rawmap with context %}

hosts_prefile:
    file.managed:
        - name: /etc/hosts
        - source: salt://proxmox/files/hosts.j2
        - template: jinja
