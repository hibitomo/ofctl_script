#!/bin/bash

function flow_transform() {
    local flow
    local script
    flow=$1
    script='s/"OUTPUT:\([^"]*\)"/{"type":"OUTPUT","port":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/NORMAL/4294967290/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/FLOOD/4294967291/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"port":ALL/"port":4294967292/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/CONTROLLER/4294967293/g'
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

    script='s/packet_type:GRE/packet_type:131119/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:VxLAN/packet_type:201397/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:GTPu/packet_type:198760/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:UDP/packet_type:131089/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:IPv4/packet_type:67584/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:ETHER/packet_type:0/g'
    flow=`echo ${flow} | sed -e "${script}"`

    script='s/cur_pkt_type:ETHER,/cur_pkt_type:0,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:IPv4,/cur_pkt_type:67584,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:UDP,/cur_pkt_type:131089,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:GTPu,/cur_pkt_type:198760,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:VxLAN,/cur_pkt_type:201397,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:GRE,/cur_pkt_type:131119,/g'
    flow=`echo ${flow} | sed -e "${script}"`

    script='s/new_pkt_type:ETHER}/new_pkt_type:0}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:IPv4}/new_pkt_type:67584}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:UDP}/new_pkt_type:131089}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:GTPu}/new_pkt_type:198760}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:VxLAN}/new_pkt_type:201397}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:GRE}/new_pkt_type:131119}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:NEXT}/new_pkt_type:65534}/g'
    flow=`echo ${flow} | sed -e "${script}"`

    script='s/"DECAP: {cur_pkt_type:\([^,]*\), new_pkt_type:\([^}]*\)}"/{"type":"DECAP","cur_pkt_type":"\1","new_pkt_type":"\2"}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s/"ENCAP: {packet_type:\([^}]*\)}"/{"type":"ENCAP","packet_type":"\1"}/g'
    flow=`echo ${flow} | sed -e "$script"`

    script='s/"GOTO_TABLE:\([1234567890]*\)"/{"type":"GOTO_TABLE","table_id":\1}/g'
    flow=`echo ${flow} | sed -e "$script"`
    script='s@"WRITE_METADATA:\(0x[1234567890abcdef]*\)/\(0x[1234567890abcdef]*\)"@{"type":"WRITE_METADATA","metadata":"\1","metadata_mask":"\2"}@g'
    flow=`echo ${flow} | sed -e "$script"`

    echo "${flow}"
}

function encap_flow_transform() {
    local flow
    local script
    flow=$1
    
    script='s/packet_type:131119/packet_type:GRE/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:201397/packet_type:VxLAN/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:198760/packet_type:GTPu/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:131089/packet_type:UDP/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:67584/packet_type:IPv4/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/packet_type:0/packet_type:ETHER/g'
    flow=`echo ${flow} | sed -e "${script}"`

    script='s/cur_pkt_type:0,/cur_pkt_type:ETHER,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:67584,/cur_pkt_type:IPv4,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:131089,/cur_pkt_type:UDP,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:198760,/cur_pkt_type:GTPu,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:201397,/cur_pkt_type:VxLAN,/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/cur_pkt_type:131119,/cur_pkt_type:GRE,/g'
    flow=`echo ${flow} | sed -e "${script}"`

    script='s/new_pkt_type:0}/new_pkt_type:ETHER}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:67584}/new_pkt_type:IPv4}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:131089}/new_pkt_type:UDP}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:198760}/new_pkt_type:GTPu}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:201397}/new_pkt_type:VxLAN}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:131119}/new_pkt_type:GRE}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    script='s/new_pkt_type:65534}/new_pkt_type:NEXT}/g'
    flow=`echo ${flow} | sed -e "${script}"`
    
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
	return 0
    elif [ "${flow::5}" = "group" ] ; then
	table_id="group"
	return 0
    elif [ "${flow::5}" = "meter" ] ; then
	table_id="meter"
	return 0
    elif [ "${flow}" = "" -o "${flow::1}" = "#" ] ; then
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
	if [ "${cmd}" = "add" ] ; then
	    group_id=`echo null | jq -c -M "${script} | .[\"group_id\"]"`
	    jq_script=".[] | map(select(.[\"group_id\"] == ${group_id})) | length"
	    if [ `curl -s -X GET ${url}/stats/groupdesc/${dpid} ${CURL_OPT} | jq "${jq_script}"` -ne 0 ] ; then
              cmd=modify
	    fi
	elif [ "${cmd::6}" = "delete" ] ; then
	    script=`echo null | jq -c -M "${script} | {dpid: .dpid, group_id: .group_id}"`
	fi
	curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/groupentry/${cmd::6} ${CURL_OPT}
    elif [ "${table_id}" = "meter" ] ; then
	if [ "${cmd}" = "add" ] ; then
	    meter_id=`echo null | jq -c -M "${script} | .[\"meter_id\"]"`
	    jq_script=".[] | map(select(.[\"meter_id\"] == ${meter_id})) | length"
	    if [ `curl -s -X GET ${url}/stats/meterconfig/${dpid} ${CURL_OPT} | jq "${jq_script}"` -ne 0 ] ; then
		cmd=modify
	    fi
	fi
	curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/meterentry/${cmd::6} ${CURL_OPT}
    else
	curl -X POST -d "`echo null | jq -c -M "${script}"`" ${url}/stats/flowentry/${cmd} ${CURL_OPT}
    fi
}
