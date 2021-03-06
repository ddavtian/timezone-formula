# This state configures the timezone.

{%- set timezone = salt['pillar.get']('timezone:lookup:name', 'America/Los_Angeles') %}
{%- set utc = salt['pillar.get']('timezone:lookup:utc', True) %}
{% from "timezone/map.jinja" import confmap with context %}

timezone_setting:
  timezone.system:
    - name: {{ timezone }}
    - utc: {{ utc }}

timezone_packages:
  pkg.installed:
    - name: {{ confmap.pkgname }}

timezone_symlink:
  file.symlink:
    - name: {{ confmap.path_localtime }}
    - target: {{ confmap.path_zoneinfo }}{{ timezone }}
    - force: true
    - require:
      - pkg: {{ confmap.pkgname }}
      