#include <core.p4>
#include <v1model.p4>

header data_t {
    bit<32> x;
}

struct metadata {
}

struct headers {
    @name("data") 
    data_t data;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract(hdr.data);
        transition accept;
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("my_drop") action my_drop() {
        mark_to_drop();
    }
    @name("set_egress_port") action set_egress_port(bit<9> egress_port) {
        standard_metadata.egress_spec = egress_port;
    }
    @name("repeater") table repeater() {
        actions = {
            my_drop;
            set_egress_port;
            @default_only NoAction;
        }
        key = {
            standard_metadata.ingress_port: exact;
        }
        default_action = NoAction();
    }
    apply {
        repeater.apply();
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.data);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
