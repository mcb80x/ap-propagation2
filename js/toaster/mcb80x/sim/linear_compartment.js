(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mcb80x.sim.LinearCompartmentModelSim = (function(_super) {

    __extends(LinearCompartmentModelSim, _super);

    function LinearCompartmentModelSim(nCompartments) {
      var c, _i, _j, _k, _len, _len1, _ref, _ref1, _ref2, _results;
      this.nCompartments = nCompartments;
      this.cIDs = (function() {
        _results = [];
        for (var _i = 0, _ref = this.nCompartments - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      this.compartments = (function() {
        var _j, _len, _ref1, _results1;
        _ref1 = this.cIDs;
        _results1 = [];
        for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
          c = _ref1[_j];
          _results1.push(mcb80x.sim.HodgkinHuxleyNeuron());
        }
        return _results1;
      }).call(this);
      this.C_m = this.prop(1.1);
      _ref1 = this.compartments;
      for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
        c = _ref1[_j];
        c.C_m = this.C_m;
      }
      this.t = this.compartments[0].t;
      this.R_a = this.prop(2.0);
      this.v = this.prop((function() {
        var _k, _len1, _ref2, _results1;
        _ref2 = this.cIDs;
        _results1 = [];
        for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
          c = _ref2[_k];
          _results1.push(0.0);
        }
        return _results1;
      }).call(this));
      this.I = this.prop((function() {
        var _k, _len1, _ref2, _results1;
        _ref2 = this.cIDs;
        _results1 = [];
        for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
          c = _ref2[_k];
          _results1.push(0.0);
        }
        return _results1;
      }).call(this));
      _ref2 = this.cIDs;
      for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
        c = _ref2[_k];
        this['v' + c] = this.prop(0.0);
        this['I' + c] = this.prop(0.0);
      }
      this.unpackArrays();
    }

    LinearCompartmentModelSim.prototype.unpackArrays = function() {
      var Is, c, vs, _i, _len, _ref, _results;
      vs = this.v();
      Is = this.I();
      _ref = this.cIDs;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        this['v' + c](vs[c]);
        _results.push(this['I' + c](Is[c]));
      }
      return _results;
    };

    LinearCompartmentModelSim.prototype.reset = function() {
      var s, _i, _len, _ref, _results;
      if (this.compartments != null) {
        _ref = this.compartments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          _results.push(s.reset());
        }
        return _results;
      }
    };

    LinearCompartmentModelSim.prototype.step = function() {
      var I, Iexts, Is, c, compartment, v_rest, vs, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      Iexts = [];
      v_rest = this.compartments[0].V_rest() + this.compartments[0].V_offset();
      _ref = this.cIDs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        I = 0.0;
        if (c > 0) {
          I += this.compartments[c - 1].v() / this.R_a();
        } else {
          I += v_rest / this.R_a();
        }
        if (c < this.nCompartments - 1) {
          I += this.compartments[c + 1].v() / this.R_a();
        } else {
          I += v_rest / this.R_a();
        }
        I -= 2 * this.compartments[c].v() / this.R_a();
        this.compartments[c].I_a(I);
      }
      _ref1 = this.compartments;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        compartment = _ref1[_j];
        compartment.step();
      }
      vs = this.v();
      Is = this.I();
      _ref2 = this.cIDs;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        c = _ref2[_k];
        vs[c] = this.compartments[c].v();
        Is[c] = this.compartments[c].I_ext();
      }
      return this.unpackArrays();
    };

    return LinearCompartmentModelSim;

  })(mcb80x.PropsEnabled);

  mcb80x.sim.LinearCompartmentModel = function(c) {
    return new mcb80x.sim.LinearCompartmentModelSim(c);
  };

}).call(this);
