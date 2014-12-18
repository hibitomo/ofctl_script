ofctl_script
============
ofctl_script is openflow control shell scripts with Ryu SDN framework
This scripts use Ryu application `ofctl_rest.py`.

Install
-------
Install Ryu SDN framework. Please see http://osrg.github.io/ryu/ .

Clone the source code.

	$ git clone git://github.com/hibitomo/ofctl_script
	$ git clone git://github.com/osrg/ryu.git

Install necessary packages

	$ sudo apt-get install jq


Setup
-----
Run OpenFlow Switch and check the datapath_id.

Run Ryu application `ofctl_rest.py`

	$ cd ryu
	$ ryu-manager ryu/app/ofctl_rest.py


Usage
-----
Configure the dataplane id and url with ofctl.conf.
Or you can use options `-d` and `-u` for all scripts.

```
$ cd ofctl_script
$ head ofctl.conf -n 2
dpid=1
url=127.0.0.1:8080
```

```
$ ./show_flow -d 1 -u 127.0.0.1:8080
```

### Show flow rules
**show_flow** can show flow rules.
```
$ ./show_flow
```

### add flow rules
**add_flow** can set single flow rule.
```
$ ./add_flow {"table_id":0,"priority":110,"packet_count":0,"actions":["OUTPUT:1"],"match":{"dl_dst":"00:00:00:01:02:03/ff:ff:ff:ff:ff:ff","in_port":2}}
```

And It can set multi flow rules with dump file made **show_flow**.
```
$ ./show_flow > flow_dump.txt
$ ./add_flow < flow_dump.txt
```

### delelte flow rules
**del_flow** can delete single flow rule.
```
$ ./del_flow {"table_id":0,"priority":110,"packet_count":0,"actions":["OUTPUT:1"],"match":{"dl_dst":"00:00:00:01:02:03/ff:ff:ff:ff:ff:ff","in_port":2}}
```

And It can delete multi flow rules with dump flow made **show_flow**.
```
$ ./show_flow > flow_dump.txt
$ ./del_flow < flow_dump.txt
```
