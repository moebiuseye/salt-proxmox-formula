{% from "proxmox/map.jinja" import rawmap with context %}

{% if rawmap.preconfigure is defined and rawmap.preconfigure %}
include:
    - proxmox.preconfig
{% endif %}

{% if salt['grains.get']('oscodename') != 'jessie' %}
proxmox_repo:
    pkgrepo.managed:
        - humanname: Proxmox VE Repository
        - name: deb http://download.proxmox.com/debian {{salt['grains.get']('oscodename')}} pve
        - dist: {{salt['grains.get']('oscodename')}}
        - file: /etc/apt/sources.list.d/pve-install-repo.list
        - key_url: http://download.proxmox.com/debian/key.asc
        - refresh_db: True
{% endif %}

proxmox_nosub_repo:
    pkgrepo.managed:
        - humanname: Proxmox VE No-Subscription Repository
        - name: deb http://download.proxmox.com/debian {{salt['grains.get']('oscodename')}} pve-no-subscription
        - dist: {{salt['grains.get']('oscodename')}}
        - file: /etc/apt/sources.list.d/pve-nosub-repo.list
        - refresh_db: True

{% if rawmap.use_enterprise %}
proxmox_ent_repo:
    pkgrepo.managed:
        - enabled: True
        - humanname: Proxmox VE Enterprise Repository
        - name: deb https://enterprise.proxmox.com/debian {{salt['grains.get']('oscodename')}} pve-enterprise
        - dist: {{salt['grains.get']('oscodename')}}
        - file: /etc/apt/sources.list.d/pve-enterprise.list
        - refresh_db: True
{% endif %}

{% for pkg in rawmap.pkgs %}
{{pkg ~ '_installed'}}:
    pkg.latest:
        - name: {{pkg}}
{% endfor %}

