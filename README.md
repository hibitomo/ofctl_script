ofctl_script
============
ofctl_script is openflow control shell scripts with Ryu SDN framework
This scripts use Ryu application *ofctl_rest.py*.

Install
-------
Install Ryu SDN framework. Please see http://osrg.github.io/ryu/ .

Clone the source code.

	$ git clone git://github.com/hibitomo/ofctl_script
	$ git clone git://github.com/osrg/ryu.git

Install necessary package

	$ sudo apt-get install jq


Setup
-----
Run OpenFlow Switch and check the datapath_id.

Run Ryu application *ofctl_rest.py*

	$ cd ryu
	$ ryu-manager [your Ryu application] ryu/app/ofctl_rest.py


Usage
-----
Configure the dataplane id and url with *ofctl.conf*.
```
$ cd ofctl_script
$ head ofctl.conf -n 2
dpid=1
url=127.0.0.1:8080
```

Or you can use options `-d` and `-u` to the scripts.
```
$ ./show_flow -d 1 -u 127.0.0.1:8080
```

### Show flow rules
*show_flow* can show and dump flow rules.
```
$ ./show_flow
$ ./show_flow > [dump file]
```
If you want to see other information in flow rules, you can configure them with *ofctl.conf*.


### add flow rules
*add_flow* can set a flow rule.
```
$ ./add_flow '{"table_id":0,"priority":110,"actions":["OUTPUT:1"],"match":{"dl_dst":"00:00:00:01:02:03/ff:ff:ff:ff:ff:ff","in_port":2}}'
$ ./add_flow -t group '{"type":"ALL","group_id":4,"buckets":[{"actions":["OUTPUT:1"]}]}'     # group_table
$ ./add_flow -t meter '{"meter_id":1,"flags":["KBPS"],"bands":[{"type":"DROP","rate":1000}]}'     # meter_table
```

And It can set multi flow rules with dump file created *show_flow*.
```
$ ./show_flow > flow_dump
$ ./add_flow < flow_dump
```
If you dump flow rules with grep, you have to configure *ofctl.conf* to show `table_id`.

**Tips**: flow integration tests
```
$ ./add_flow < flow_dump_appA
$ ./add_flow < flow_dump_appB
$ ### Your flow integration test ###
```

### delete flow rules
*del_flow* can delete the flow rule.
```
$ ./del_flow '{"table_id":0,"priority":110,"actions":["OUTPUT:1"],"match":{"dl_dst":"00:00:00:01:02:03/ff:ff:ff:ff:ff:ff","in_port":2}}'
$ ./del_flow -t group '{"type":"ALL","group_id":4,"buckets":[{"actions":["OUTPUT:1"]}]}'     # group_table
$ ./del_flow -t meter '{"meter_id":1,"flags":["KBPS"],"bands":[{"type":"DROP","rate":1000}]}'     # meter_table
```

And It can delete multi flow rules with dump flow created *show_flow*.
```
$ ./show_flow > flow_dump
$ ./del_flow < flow_dump
```
If you dump flow rules with grep, you have to configure *ofctl.conf* to show `table_id`.

**Tips**: Delete all flow rules
```
$ ./show_flow | ./del_flow
```

Configuration datapath_id
----------------------------
### Lagopus
You can set the datapath_id with *lagopus.dsl*.

```
channel channel01 create -dst-addr 127.0.0.1 -protocol tcp
controller controller01 create -channel channel01 -role equal -connection-type main

interface interface0 create -type ethernet-dpdk-phy -port-number 0
interface interface1 create -type ethernet-dpdk-phy -port-number 1

port port01 create -interface interface0
port port02 create -interface interface1

bridge bridge01 create -controller controller01 -port port01 1 -port port02 2 -port -dpid 0x1
bridge bridge01 enable
```

### Open vSwitch
You can set the datapath_id by *ovs-vsctl*.

```
# ovs-vsctl set bridge br0 other-config:datapath-id=0000000000000001
```
