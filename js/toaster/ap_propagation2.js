(function() {
  var ApPropagation2, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ApPropagation2 = (function(_super) {

    __extends(ApPropagation2, _super);

    function ApPropagation2() {
      this.duration = ko.observable(10.0);
      this.stimCompIndex = ko.observable(0);
      this.voltageClamped = ko.observable(false);
      this.clampVoltage = ko.observable(-65.0);
      this.XVPlotVRange = [-80, 50];
    }

    ApPropagation2.prototype.init = function() {
      var stimCompartment,
        _this = this;
      this.myelinatedSim = mcb80x.sim.MyelinatedLinearCompartmentModel(24, 4).C_m(0.9);
      this.unmyelinatedSim = mcb80x.sim.LinearCompartmentModel(36).C_m(1.1);
      this.sim = this.unmyelinatedSim;
      this.sim.R_a(0.25);
      this.pulseAmplitude = ko.observable(180.0);
      this.myelinated = ko.observable(0);
      this.clampVoltage = ko.observable(-65.0);
      this.xvPath = this.svg.append('path');
      this.oscopes = [];
      this.oscopes.push(oscilloscope('#art svg', '#oscope1'));
      util.floatOverRect('#art svg', '#propertiesRect', '#floaty');
      svgbind.bindVisible('#myelin', this.myelinated);
      this.myelinated.subscribe(function(v) {
        return _this.myelinate(v);
      });
      svgbind.bindSlider('#vKnob', '#XVPlot', 'v', this.clampVoltage, d3.scale.linear().domain([0, 1]).range(this.XVPlotVRange));
      svgbind.bindVisible('#vKnob', this.voltageClamped);
      this.voltageClamped.subscribe(function() {
        return _this.setup();
      });
      svgbind.bindMultiState({
        '#VoltageClamp': true,
        '#CurrentStimulator': false
      }, this.voltageClamped);
      stimCompartment = this.sim.compartments[this.stimCompIndex()];
      this.pulse = mcb80x.sim.CurrentPulse().I_stim(stimCompartment.I_ext).t(this.sim.t);
      this.pulse.amplitude = this.pulseAmplitude;
      this.inheritProperties(this.pulse, ['stimOn']);
      svgbind.bindAsMomentaryButton('#stimOn', '#stimOff', this.stimOn);
      return this.setup();
    };

    ApPropagation2.prototype.setup = function() {
      var nCompartments, oscopeCompartment, scope, stimCompartment, xvbbox, _i, _len, _ref,
        _this = this;
      this.inheritProperties(this.sim);
      stimCompartment = this.sim.compartments[this.stimCompIndex()];
      if (this.voltageClamped()) {
        stimCompartment.voltageClamped(true);
        stimCompartment.clampVoltage(this.clampVoltage);
        console.log('applying voltage clamp');
      } else {
        stimCompartment.voltageClamped(false);
        console.log('clearing voltage clamp: ' + stimCompartment.voltageClamped());
        this.pulse.I_stim(stimCompartment.I_ext);
      }
      ko.applyBindings(this);
      oscopeCompartment = this.sim.compartments[32];
      this.oscopes[0].data(function() {
        return [_this.sim.t(), oscopeCompartment.v()];
      });
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
      this.vScale = d3.scale.linear().domain(this.XVPlotVRange).range([xvbbox.y + xvbbox.height, xvbbox.y]);
      this.xvLine = d3.svg.line().interpolate('basis').x(function(d, i) {
        return _this.xScale(i);
      }).y(function(d, i) {
        return _this.vScale(d);
      });
      return this.xvPath.data([this.I()]).attr('class', 'xv-line').attr('d', this.xvLine);
    };

    ApPropagation2.prototype.play = function() {
      var update,
        _this = this;
      update = function() {
        var scope, _i, _len, _ref;
        _this.sim.step();
        _ref = _this.oscopes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          scope = _ref[_i];
          scope.plot();
        }
        return _this.xvPath.data([_this.sim.v()]).attr('d', _this.xvLine);
      };
      return this.updateTimer = setInterval(update, 10);
    };

    ApPropagation2.prototype.stop = function() {
      var scope, _i, _len, _ref, _results;
      if (this.updateTimer) {
        clearInterval(this.updateTimer);
      }
      this.sim.reset();
      _ref = this.oscopes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        scope = _ref[_i];
        _results.push(scope.reset());
      }
      return _results;
    };

    ApPropagation2.prototype.myelinate = function(v) {
      this.stop();
      if (v) {
        this.sim = this.myelinatedSim;
        this.sim.R_a(0.35);
        this.sim.C_m(0.5);
        $('#CSlider').slider('enable');
      } else {
        this.sim = this.unmyelinatedSim;
        this.sim.R_a(0.45);
        this.sim.C_m(1.1);
        $('#CSlider').slider('disable');
      }
      this.setup();
      return this.play();
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
      return d3.xml('svg/ap_propagation2.svg', 'image/svg+xml', function(xml) {
        return _this.svgDocumentReady(xml);
      });
    };

    ApPropagation2.prototype.hide = function() {
      this.runSimulation = false;
      return d3.select('#interactive').transition().style('opacity', 0.0).duration(1000);
    };

    return ApPropagation2;

  })(mcb80x.ViewModel);

  root = typeof window !== "undefined" && window !== null ? window : exports;

  root.stages.approp2 = new ApPropagation2();

}).call(this);
