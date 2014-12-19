#!/bin/bash

function flow_transform() {
    local flow
    local script
    flow=$1
    script='s/"OUTPUT:\([^"]*\)"/{"type":"OUTPUT","port":"\1"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/controller/4294967293/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"COPY_TTL_OUT"/{"type":"COPY_TTL_OUT"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"COPY_TTL_IN"/{"type":"COPY_TTL_IN"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"SET_MPLS_TTL:\([1234567890]*\)"/{"type":"SET_MPLS_TTL","mpls_ttl":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"DEC_MPLS_TTL"/{"type":"DEC_MPLS_TTL"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"PUSH_VLAN:\([1234567890]*\)"/{"type":"PUSH_VLAN","ethertype":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"POP_VLAN"/{"type":"POP_VLAN"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"PUSH_MPLS:\([1234567890]*\)"/{"type":"PUSH_MPLS","ethertype":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"POP_MPLS:\([1234567890]*\)"/{"type":"POP_MPLS","ethertype":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"SET_QUEUE:\([1234567890]*\)"/{"type":"SET_QUEUE","queue_id":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"GROUP:\([1234567890]*\)"/{"type":"GROUP","group_id":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"SET_NW_TTL:\([1234567890]*\)"/{"type":"SET_NW_TTL","nw_ttl":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"DEC_NW_TTL"/{"type":"DEC_NW_TTL"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"SET_FIELD: {\([^:]*\):\([^"]*\)}"/{"type":"SET_FIELD","field":"\1","value":"\2"}/g'
    flow=`echo ${flow} | sed -e "$script"`    
    script='s/"PUSH_PBB:\([1234567890]*\)"/{"type":"PUSH_PBB","ethertype":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"POP_PBB"/{"type":"POP_PBB"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"GOTO_TABLE:\([1234567890]*\)"/{"type":"GOTO_TABLE","table_id":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s@"WRITE_METADATA:\(0x[1234567890abcdef]*\)/\(0x[1234567890abcdef]*\)"@{"type":"WRITE_METADATA","metadata":"\1","metadata_mask":"\2"}@g'
    flow=`echo ${flow} | sed -e "$script"`

    echo "${flow}"
}

function set_flow() {
    local script
    local cmd
    local flow

    cmd=$1
    flow=$2

    if [ "${flow::5}" = "table" ] ; then
	table_id="${flow:6}"
	continue
    elif [ "${flow::5}" = "group" -o "${flow::5}" = "meter" ] ; then
	echo "Unsupported group and meter table"
	exit 1
    elif [ "${flow}" = "" ] ; then
	return 0
    fi

    if echo ${flow} | grep -q '"table_id"' ; then
	script='{"dpid":'${dpid}'} + '
    else
	script='{"dpid":'${dpid}'} + {"table_id":'${table_id}'} + '
    fi

    flow=`flow_transform "${flow}"`
    script+="${flow}"

    curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/flowentry/${cmd}
}
