#include <core.p4>

control c(inout bit<32> arg) {
    action a() {
    }
    action b() {
    }
    table t(in bit<32> x) {
        key = {
            x: exact;
        }
        actions = {
            a();
            b();
        }
        default_action = a();
    }
    apply {
        switch (t.apply(arg).action_run) {
            a: {
                t.apply(arg);
            }
            b: {
                arg = arg + 32w1;
            }
        }

    }
}

control proto(inout bit<32> arg);
package top(proto p);
top(c()) main;
