# 📗 do-ansible-inventory

do-ansible-inventory is a tool that generates an [Ansible inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) file with your DigitalOcean Droplets. It is an alternative to [dynamic inventories](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#intro-dynamic-inventory) as you can run do-ansible-inventory once and receive a static inventory file that you can use anywhere, copy, or modify.

## Installation

1. Download the latest release from [the releases page](https://github.com/do-community/do-ansible-inventory/releases).
2. Extract the downloaded archive and place the binary `do-ansible-inventory` wherever you like. Preferably to any directory in your `$PATH` such as `~/bin` if it exists or `/usr/local/bin` so you can easily access it.

## Usage

To use do-ansible-inventory, run:

```
do-ansible-inventory
```

By default, without setting any options, do-ansible-inventory will attempt to look up the currently configured [doctl](https://github.com/digitalocean/doctl) access token and generate an ansible inventory with:

* All of your Droplets as Ansible hosts
* Each DigitalOcean region as an Ansible group containing any Droplets in that region
* Each Droplet tag as a group containing any Droplets with that tag

If you do not have `doctl` installed or would like to explicitly specify the access token, run `do-ansible-inventory --access-token ACCESS_TOKEN` or use the `DIGITALOCEAN_ACCESS_TOKEN` environment variable.

The resulting inventory will be printed to the console. You can save it to a file instead by passing `--out inventory` or redirecting the output like so: `do-ansible-inventory > inventory`.

### Supported Options

* `-t TOKEN`, `--access-token TOKEN` - DigitalOcean API Token - if unset, do-ansible-inventory attempts to use doctl's stored token of its current default context. Alternatively, use the environment variable `DIGITALOCEAN_ACCESS_TOKEN`
* `--ssh-user USER` - sets the `ansible_user` property on the hosts (Droplets)
* `--ssh-port PORT` - sets the `ansible_port` property on the hosts (Droplets)
* `--tag TAG` - limits the inventory to only Droplets with the specified tag
* `--ignore HOSTNAME` - pass a Droplet's hostname to exclude it from the inventory. **This option can be used multiple times**
* `--group-by-region` - create groups for each DigitalOcean region. Default behavior.
   * `--no-group-by-region` - do not create groups for each DigitalOcean region.
* `--group-by-tag` - create groups for each Droplet tag. Default behavior.
   * `--no-group-by-tag` - do not create groups for each Droplet tag. 
* `--group-by-project` - create groups for each Droplet projects. Default behavior.
   * `--no-group-by-project` - do not create groups for each Droplet project. 
* `--private-ips` - use private Droplet IPs instead of public IPs
* `--out FILE` - write the ansible inventory to this file - if unset, print to stdout
* `--timeout=2m` - timeout for total runtime of the command, defaults to `2m`

## Example

Running:

```
$ do-ansible-inventory --out ./inventory
```

will output:

```
   • no access token provided, attempting to look up doctl's access token
   • using doctl access token  context=default
   • processing                droplet=speedtest-ams2.digitalocean.com
   • processing                droplet=speedtest-nyc2.digitalocean.com
   • processing                droplet=speedtest-sfo1.digitalocean.com
   • processing                droplet=speedtest-ams3.digitalocean.com
   • processing                droplet=speedtest-blr1.digitalocean.com
   • processing                droplet=speedtest-fra1.digitalocean.com
   • processing                droplet=speedtest-lon1.digitalocean.com
   • processing                droplet=speedtest-nyc1.digitalocean.com
   • processing                droplet=speedtest-nyc3.digitalocean.com
   • processing                droplet=speedtest-sfo2.digitalocean.com
   • processing                droplet=speedtest-sgp1.digitalocean.com
   • processing                droplet=speedtest-tor1.digitalocean.com
   • building region group     region=ams1
   • building region group     region=ams2
   • building region group     region=ams3
   • building region group     region=blr1
   • building region group     region=fra1
   • building region group     region=lon1
   • building region group     region=nyc1
   • building region group     region=nyc2
   • building region group     region=nyc3
   • building region group     region=sfo1
   • building region group     region=sfo2
   • building region group     region=sfo3
   • building region group     region=sgp1
   • building region group     region=tor1
   • building tag group        tag=speedtests
   • done!
```

with the resulting file `inventory` containing:

```
speedtest-ams2.digitalocean.com ansible_host=188.226.175.227
speedtest-nyc2.digitalocean.com ansible_host=192.241.184.88
speedtest-sfo1.digitalocean.com ansible_host=107.170.223.15
speedtest-ams3.digitalocean.com ansible_host=178.62.216.76
speedtest-blr1.digitalocean.com ansible_host=139.59.80.215
speedtest-fra1.digitalocean.com ansible_host=46.101.218.147
speedtest-lon1.digitalocean.com ansible_host=46.101.44.214
speedtest-nyc1.digitalocean.com ansible_host=165.227.194.167
speedtest-nyc3.digitalocean.com ansible_host=174.138.51.137
speedtest-sfo2.digitalocean.com ansible_host=165.227.29.84
speedtest-sgp1.digitalocean.com ansible_host=159.89.192.182
speedtest-tor1.digitalocean.com ansible_host=159.203.57.38

[ams1]

[ams2]
speedtest-ams2.digitalocean.com

[ams3]
speedtest-ams3.digitalocean.com

[blr1]
speedtest-blr1.digitalocean.com

[fra1]
speedtest-fra1.digitalocean.com

[lon1]
speedtest-lon1.digitalocean.com

[nyc1]
speedtest-nyc1.digitalocean.com

[nyc2]
speedtest-nyc2.digitalocean.com

[nyc3]
speedtest-nyc3.digitalocean.com

[sfo1]
speedtest-sfo1.digitalocean.com

[sfo2]
speedtest-sfo2.digitalocean.com

[sfo3]

[sgp1]
speedtest-sgp1.digitalocean.com

[tor1]

[speedtests]
speedtest-ams2.digitalocean.com
speedtest-nyc2.digitalocean.com
speedtest-sfo1.digitalocean.com
speedtest-ams3.digitalocean.com
speedtest-blr1.digitalocean.com
speedtest-fra1.digitalocean.com
speedtest-lon1.digitalocean.com
speedtest-nyc1.digitalocean.com
speedtest-nyc3.digitalocean.com
speedtest-sfo2.digitalocean.com
speedtest-sgp1.digitalocean.com
speedtest-tor1.digitalocean.com
```

---

```
usage: do-ansible-inventory [<flags>]

Flags:
  -t, --access-token=ACCESS-TOKEN  
                           DigitalOcean API Token - if unset, attempts to use doctl's stored token of its current default context. env var:
                           DIGITALOCEAN_ACCESS_TOKEN
      --ssh-user=SSH-USER  default ssh user
      --ssh-port=SSH-PORT  default ssh port
      --tag=TAG            filter droplets by tag
      --ignore=IGNORE ...  ignore a Droplet by name, can be specified multiple times
      --group-by-region    group hosts by region, defaults to true
      --group-by-tag       group hosts by their Droplet tags, defaults to true
      --group-by-project   group hosts by their Projects, defaults to true
      --private-ips        use private Droplet IPs instead of public IPs
      --out=OUT            write the ansible inventory to this file - if unset, print to stdout
      --timeout=2m         timeout for total runtime of the command, defaults to 2m
```
