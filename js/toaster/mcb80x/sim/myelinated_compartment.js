(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mcb80x.sim.MyelinatedLinearCompartmentModelSim = (function(_super) {

    __extends(MyelinatedLinearCompartmentModelSim, _super);

    function MyelinatedLinearCompartmentModelSim(nCompartments, nNodes) {
      var c, interNodeDistance, n, passive, _i, _j, _k, _l, _len, _ref, _ref1, _ref2, _results;
      this.nCompartments = nCompartments;
      this.nNodes = nNodes;
      interNodeDistance = (this.nCompartments - this.nNodes) / (this.nNodes - 1);
      this.nodeIndices = [];
      this.C_m = this.prop(1.1);
      this.compartments = [];
      for (n = _i = 0, _ref = this.nNodes; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
        this.compartments.push(new mcb80x.sim.HHSimulationRK4());
        this.nodeIndices.push(this.compartments.length - 1);
        for (c = _j = 0; 0 <= interNodeDistance ? _j <= interNodeDistance : _j >= interNodeDistance; c = 0 <= interNodeDistance ? ++_j : --_j) {
          passive = new mcb80x.sim.PassiveMembrane();
          passive.C_m = this.C_m;
          this.compartments.push(passive);
        }
      }
      this.t = this.compartments[0].t;
      this.R_a = this.prop(1.0);
      this.nCompartments = this.compartments.length;
      this.cIDs = (function() {
        _results = [];
        for (var _k = 0, _ref1 = this.nCompartments - 1; 0 <= _ref1 ? _k <= _ref1 : _k >= _ref1; 0 <= _ref1 ? _k++ : _k--){ _results.push(_k); }
        return _results;
      }).apply(this);
      this.v = this.prop((function() {
        var _l, _len, _ref2, _results1;
        _ref2 = this.cIDs;
        _results1 = [];
        for (_l = 0, _len = _ref2.length; _l < _len; _l++) {
          c = _ref2[_l];
          _results1.push(0.0);
        }
        return _results1;
      }).call(this));
      this.I = this.prop((function() {
        var _l, _len, _ref2, _results1;
        _ref2 = this.cIDs;
        _results1 = [];
        for (_l = 0, _len = _ref2.length; _l < _len; _l++) {
          c = _ref2[_l];
          _results1.push(0.0);
        }
        return _results1;
      }).call(this));
      _ref2 = this.cIDs;
      for (_l = 0, _len = _ref2.length; _l < _len; _l++) {
        c = _ref2[_l];
        this['v' + c] = this.prop(0.0);
        this['I' + c] = this.prop(0.0);
      }
      this.unpackArrays();
    }

    MyelinatedLinearCompartmentModelSim.prototype.unpackArrays = function() {
      var c, _i, _len, _ref, _results;
      _ref = this.cIDs;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        this['v' + c](this.v()[c]);
        _results.push(this['I' + c](this.I()[c]));
      }
      return _results;
    };

    MyelinatedLinearCompartmentModelSim.prototype.reset = function() {
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

    MyelinatedLinearCompartmentModelSim.prototype.step = function() {
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

    return MyelinatedLinearCompartmentModelSim;

  })(mcb80x.PropsEnabled);

  mcb80x.sim.MyelinatedLinearCompartmentModel = function(c, n) {
    return new mcb80x.sim.MyelinatedLinearCompartmentModelSim(c, n);
  };

}).call(this);
