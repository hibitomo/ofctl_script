#!/bin/bash

function flow_transform() {
    local flow
    local script
    flow=$1
    script='s/"OUTPUT:\([^"]*\)"/{"type":"OUTPUT","port":"\1"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/controller/4294967293/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"COPY_TTL_OUT"[\t\n\r\f\v]*\([^}]\)/{"type":"COPY_TTL_OUT"}\1/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"COPY_TTL_IN"[\t\n\r\f\v]*\([^}]\)/{"type":"COPY_TTL_IN"}\1/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"SET_MPLS_TTL:\([1234567890]*\)"/{"type":"SET_MPLS_TTL","mpls_ttl":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"DEC_MPLS_TTL"[\t\n\r\f\v]*\([^}]\)/{"type":"DEC_MPLS_TTL"}\1/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"PUSH_VLAN:\([1234567890]*\)"/{"type":"PUSH_VLAN","ethertype":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"POP_VLAN"[\t\n\r\f\v]*\([^}]\)/{"type":"POP_VLAN"}\1/g'
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
    script='s/"DEC_NW_TTL"[\t\n\r\f\v]*\([^}]\)/{"type":"DEC_NW_TTL"}\1/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"SET_FIELD: {\([^:]*\):\([^"]*\)}"/{"type":"SET_FIELD","field":"\1","value":"\2"}/g'
    flow=`echo ${flow} | sed -e "$script"`    
    script='s/"value":"\([0123456789]*\)"/"value":\1/g'
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
    elif [ "${flow::5}" = "group" ] ; then
	table_id="group"
	continue
    elif [ "${flow::5}" = "meter" ] ; then
	table_id="meter"
	continue
    elif [ "${flow}" = "" ] ; then
	return 0
    fi

    if echo ${flow} | grep -q '"table_id"' ; then
	script='{"dpid":"'${dpid}'"} + '
    elif [ "${table_id}" = "group" -o "${table_id}" = "meter" ] ; then
	script='{"dpid":"'${dpid}'"} + '
    else
	script='{"dpid":"'${dpid}'"} + {"table_id":'${table_id}'} + '
    fi

    flow=`flow_transform "${flow}"`
    script+="${flow}"

    if [ "${table_id}" = "group" ] ; then
	curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/groupentry/${cmd::6}
    elif [ "${table_id}" = "meter" ] ; then
	curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/meterentry/${cmd::6}
    else
	curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/flowentry/${cmd}
    fi
}
