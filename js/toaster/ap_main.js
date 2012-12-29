(function() {
  var LinearCompartmentModel, SquareWavePulse, ViewModel, initializeSimulation, svgDocumentReady;

  LinearCompartmentModel = common.sim.LinearCompartmentModel;

  SquareWavePulse = common.sim.SquareWavePulse;

  ViewModel = common.ViewModel;

  initializeSimulation = function() {
    var maxSimTime, oscopes, pulse, scope, sim, update, updateTimer, vm, _i, _len;
    sim = LinearCompartmentModel(10).R_a(10.0);
    pulse = SquareWavePulse().interval([1.0, 1.5]).amplitude(25.0).I_stim(sim.compartments[0].I_ext).t(sim.t);
    vm = new ViewModel();
    vm.inheritProperties(sim, ['t', 'v0', 'v1', 'v2', 'v3', 'I0', 'I1', 'I2', 'I3', 'R_a']);
    vm.inheritProperties(pulse, ['stimOn']);
    svgbind.bindMultiState({
      '#stimOff': false,
      '#stimOn': true
    }, vm.stimOn);
    ko.applyBindings(vm);
    oscopes = [];
    oscopes[0] = oscilloscope('#art svg', '#oscope1').data(function() {
      return [sim.t(), sim.v0()];
    });
    oscopes[1] = oscilloscope('#art svg', '#oscope2').data(function() {
      return [sim.t(), sim.v1()];
    });
    oscopes[2] = oscilloscope('#art svg', '#oscope3').data(function() {
      return [sim.t(), sim.v2()];
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
      for (_j = 0, _len1 = oscopes.length; _j < _len1; _j++) {
        scope = oscopes[_j];
        scope.plot();
      }
      if (sim.t() >= maxSimTime) {
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
