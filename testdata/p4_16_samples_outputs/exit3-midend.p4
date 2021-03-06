control ctrl(out bit<32> c) {
    bool hasExited;
    bit<32> a;
    bool tmp_0;
    @name("e") action e_0() {
        hasExited = true;
    }
    @name("t") table t() {
        actions = {
            e_0();
        }
        default_action = e_0();
    }
    action act() {
        hasExited = false;
        a = 32w0;
        c = 32w2;
        tmp_0 = a == 32w0;
    }
    action act_0() {
        c = 32w5;
    }
    table tbl_act() {
        actions = {
            act();
        }
        const default_action = act();
    }
    table tbl_act_0() {
        actions = {
            act_0();
        }
        const default_action = act_0();
    }
    apply {
        tbl_act.apply();
        if (tmp_0) 
            t.apply();
        else 
            t.apply();
        if (!hasExited) 
            tbl_act_0.apply();
    }
}

control noop(out bit<32> c);
package p(noop _n);
p(ctrl()) main;
