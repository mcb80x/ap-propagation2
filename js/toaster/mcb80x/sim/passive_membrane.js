(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mcb80x.sim.PassiveMembraneSim = (function(_super) {

    __extends(PassiveMembraneSim, _super);

    function PassiveMembraneSim() {
      this.I_ext = this.prop(0.0);
      this.I_a = this.prop(0.0);
      this.dt = this.prop(0.05);
      this.C_m = this.prop(1.0);
      this.g_L = this.prop(0.3);
      this.V_rest = this.prop(0.0);
      this.V_offset = this.prop(-65.0);
      this.E_L = this.prop(10.6 + this.V_rest());
      this.defineProps(['I_L', 'g_L'], 0.0);
      this.v = this.prop(0.0);
      this.t = this.prop(0.0);
      this.reset();
      this.rk4 = false;
    }

    PassiveMembraneSim.prototype.reset = function() {
      this.v(this.V_rest());
      this.state = this.v();
      return this.t(0.0);
    };

    PassiveMembraneSim.prototype.step = function(stepCallback) {
      var dt, k1, k2, k3, k4, t;
      this.t(this.t() + this.dt());
      t = this.t();
      dt = this.dt();
      k1 = this.ydot(t, this.state);
      if (this.rk4) {
        k2 = this.ydot(t + (dt / 2), this.state + (dt * k1 / 2));
        k3 = this.ydot(t + dt / 2, this.state + (dt * k2 / 2));
        k4 = this.ydot(t + dt, this.state + dt * k3);
        this.state = this.state + (dt / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4);
      } else {
        this.state = this.state + dt * k1;
      }
      this.v(this.state + this.V_offset());
      if (stepCallback != null) {
        return stepCallback();
      }
    };

    PassiveMembraneSim.prototype.ydot = function(t, s) {
      var dv, v;
      v = s;
      this.I_L(this.g_L() * (v - this.E_L()));
      dv = (this.I_ext() + this.I_a() - this.I_L()) / this.C_m();
      return dv;
    };

    return PassiveMembraneSim;

  })(mcb80x.PropsEnabled);

  mcb80x.sim.PassiveMembrane = function() {
    return new mcb80x.sim.PassiveMembraneSim;
  };

}).call(this);
