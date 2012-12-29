(function() {
  var LinearCompartmentModel, SquareWavePulse, b, initializeSimulation, root, svgDocumentReady, util;

  root = typeof window !== "undefined" && window !== null ? window : exports;

  b = bindings;

  LinearCompartmentModel = common.sim.LinearCompartmentModel;

  SquareWavePulse = common.sim.SquareWavePulse;

  util = root.util;

  initializeSimulation = function() {
    var maxSimTime, oscopes, pulse, scope, sim, update, updateTimer, viewModel, _i, _len;
    sim = new LinearCompartmentModel(10);
    pulse = new SquareWavePulse([0.0, 3.0], 15.0);
    viewModel = {};
    b.exposeOutputBindings(sim, ['t', 'v0', 'v1', 'v2', 'v3', 'I0', 'I1', 'I2', 'I3'], viewModel);
    b.exposeInputBindings(sim, ['R_a'], viewModel);
    b.bindOutput(pulse, 'I_stim', viewModel, 'I_stim');
    b.bindInput(pulse, 't', viewModel, 't', function() {
      return pulse.update();
    });
    b.bindInput(sim.compartments[0], 'I_ext', viewModel, 'I_stim');
    ko.applyBindings(viewModel);
    oscopes = [];
    oscopes[0] = oscilloscope('#art svg', '#oscope1').data(function() {
      return [sim.t, sim.v1];
    });
    oscopes[1] = oscilloscope('#art svg', '#oscope2').data(function() {
      return [sim.t, sim.v2];
    });
    oscopes[2] = oscilloscope('#art svg', '#oscope3').data(function() {
      return [sim.t, sim.v3];
    });
    util.floatOverRect('#art svg', '#propertiesRect', '#floaty');
    maxSimTime = 10.0;
    for (_i = 0, _len = oscopes.length; _i < _len; _i++) {
      scope = oscopes[_i];
      scope.maxX = maxSimTime;
    }
    update = function() {
      var _j, _k, _len1, _len2, _results;
      sim.step();
      b.update();
      for (_j = 0, _len1 = oscopes.length; _j < _len1; _j++) {
        scope = oscopes[_j];
        scope.plot();
      }
      if (sim.t >= maxSimTime) {
        sim.reset();
        _results = [];
        for (_k = 0, _len2 = oscopes.length; _k < _len2; _k++) {
          scope = oscopes[_k];
          _results.push(scope.reset());
        }
        return _results;
      }
    };
    return updateTimer = setInterval(update, 50);
  };

  svgDocumentReady = function(xml) {
    var importedNode;
    importedNode = document.importNode(xml.documentElement, true);
    d3.select('#art').node().appendChild(importedNode);
    return initializeSimulation();
  };

  $(function() {
    return d3.xml('svg/ap_propagation.svg', 'image/svg+xml', svgDocumentReady);
  });

}).call(this);
