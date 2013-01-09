(function() {
  var ApPropagation2, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ApPropagation2 = (function(_super) {

    __extends(ApPropagation2, _super);

    function ApPropagation2() {
      this.duration = ko.observable(10.0);
    }

    ApPropagation2.prototype.init = function() {
      this.myelinatedSim = mcb80x.sim.MyelinatedLinearCompartmentModel(24, 4).C_m(0.9);
      this.unmyelinatedSim = mcb80x.sim.LinearCompartmentModel(24);
      this.sim = this.myelinatedSim;
      this.sim.R_a(0.25);
      this.pulseAmplitude = ko.observable(180.0);
      return this.setup();
    };

    ApPropagation2.prototype.setup = function() {
      var nCompartments, oscopeCompartment, scope, xvbbox, _i, _len, _ref,
        _this = this;
      this.pulse = mcb80x.sim.SquareWavePulse().interval([1.0, 1.5]).I_stim(this.sim.compartments[0].I_ext).t(this.sim.t);
      this.pulse.amplitude = this.pulseAmplitude;
      this.inheritProperties(this.sim);
      this.inheritProperties(this.pulse, ['stimOn']);
      svgbind.bindMultiState({
        '#stimOff': false,
        '#stimOn': true
      }, this.stimOn);
      ko.applyBindings(this);
      this.oscopes = [];
      oscopeCompartment = this.sim.compartments[32];
      this.oscopes.push(oscilloscope('#art svg', '#oscope1').data(function() {
        return [_this.sim.t(), oscopeCompartment.v()];
      }));
      util.floatOverRect('#art svg', '#propertiesRect', '#floaty');
      this.maxSimTime = 30.0;
      _ref = this.oscopes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        scope = _ref[_i];
        scope.maxX = this.maxSimTime;
      }
      this.iterations = 0;
      this.updateTimer = void 0;
      this.xvplot = d3.select('#XVPlot');
      this.xvplot.attr('opacity', 0.0);
      xvbbox = this.xvplot.node().getBBox();
      nCompartments = this.sim.compartments.length;
      this.xScale = d3.scale.linear().domain([0, nCompartments]).range([xvbbox.x, xvbbox.x + xvbbox.width]);
      this.vScale = d3.scale.linear().domain([-80, 50]).range([xvbbox.y + xvbbox.height, xvbbox.y]);
      console.log(this.nCompartments);
      console.log(xvbbox);
      console.log(this.xScale(5));
      console.log(this.xScale(100));
      this.xvLine = d3.svg.line().interpolate('basis').x(function(d, i) {
        return _this.xScale(i);
      }).y(function(d, i) {
        return _this.vScale(d);
      });
      return this.xvPath = this.svg.append('path').data([this.I()]).attr('class', 'xv-line').attr('d', this.xvLine);
    };

    ApPropagation2.prototype.play = function() {
      var update,
        _this = this;
      update = function() {
        var scope, _i, _j, _len, _len1, _ref, _ref1;
        _this.sim.step();
        _ref = _this.oscopes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          scope = _ref[_i];
          scope.plot();
        }
        _this.xvPath.data([_this.sim.v()]).attr('d', _this.xvLine);
        if (_this.sim.t() >= _this.maxSimTime) {
          _this.sim.reset();
          _ref1 = _this.oscopes;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            scope = _ref1[_j];
            scope.reset();
          }
          return _this.iterations += 1;
        }
      };
      return this.updateTimer = setInterval(update, 10);
    };

    ApPropagation2.prototype.stop = function() {
      if (this.updateTimer) {
        return clearInterval(this.updateTimer);
      }
    };

    ApPropagation2.prototype.myelinated = function(v) {
      if (v != null) {
        if (v) {
          this.sim = this.myelinatedSim;
        } else {
          this.sim = this.unmyelinatedSim;
        }
        return this.setup();
      } else {
        return this.sim === this.myelinatedSim;
      }
    };

    ApPropagation2.prototype.svgDocumentReady = function(xml) {
      var importedNode;
      importedNode = document.importNode(xml.documentElement, true);
      d3.select('#art').node().appendChild(importedNode);
      d3.select('#art').transition().style('opacity', 1.0).duration(1000);
      this.svg = d3.select(importedNode);
      this.svg.attr('width', '100%');
      this.svg.attr('height', '100%');
      return this.init();
    };

    ApPropagation2.prototype.show = function() {
      var _this = this;
      console.log('showing hodghux');
      return d3.xml('svg/ap_propagation2.svg', 'image/svg+xml', function(xml) {
        return _this.svgDocumentReady(xml);
      });
    };

    ApPropagation2.prototype.hide = function() {
      this.runSimulation = false;
      return d3.select('#art').transition().style('opacity', 0.0).duration(1000);
    };

    return ApPropagation2;

  })(mcb80x.ViewModel);

  root = typeof window !== "undefined" && window !== null ? window : exports;

  root.stages.approp2 = new ApPropagation2();

}).call(this);
