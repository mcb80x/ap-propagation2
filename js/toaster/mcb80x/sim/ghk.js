(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mcb80x.sim.GHKSim = (function(_super) {

    __extends(GHKSim, _super);

    function GHKSim() {
      var p, _i, _len, _ref,
        _this = this;
      this.Na_extra = this.prop(0.0);
      this.Na_intra = this.prop(0.0);
      this.K_extra = this.prop(0.0);
      this.K_intra = this.prop(0.0);
      this.Cl_extra = this.prop(0.0);
      this.Cl_intra = this.prop(0.0);
      this.Ca_extra = this.prop(0.0);
      this.Ca_intra = this.prop(0.0);
      this.P_Na = this.prop(1.0);
      this.P_K = this.prop(1.0);
      this.P_Cl = this.prop(1.0);
      this.P_Ca = this.prop(1.0);
      this.T = this.prop(310.0);
      this.E_m = this.prop(0.0);
      this.F = 96485.3365;
      this.R = 8.3144621;
      _ref = [this.Na_extra, this.Na_intra, this.K_extra, this.K_intra, this.Cl_extra, this.Cl_intra, this.Ca_extra, this.Ca_intra, this.P_Na, this.P_K, this.P_Cl, this.P_Ca, this.T];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        p.subscribe(function() {
          return _this.update();
        });
      }
    }

    GHKSim.prototype.update = function() {
      var denominator, numerator, v;
      numerator = this.P_Na() * this.Na_extra() + this.P_K() * this.K_extra() + this.P_Cl() * this.Cl_intra() + this.P_Ca() * this.Ca_extra();
      denominator = this.P_Na() * this.Na_intra() + this.P_K() * this.K_intra() + this.P_Cl() * this.Cl_extra() + this.P_Ca() * this.Ca_intra();
      v = (this.R / this.F) * this.T() * Math.log(numerator / denominator);
      return this.E_m(v);
    };

    return GHKSim;

  })(mcb80x.PropsEnabled);

  mcb80x.sim.GHK = function() {
    return new mcb80x.sim.GHKSim();
  };

}).call(this);
