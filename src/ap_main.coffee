# ----------------------------------------------------
# Imports (using coffee-toaster directives)
# ----------------------------------------------------

#<< common/bindings
#<< common/oscilloscope
#<< common/sim/linear_compartment
#<< common/sim/stim
#<< common/util

# Import a few names into this namespace for convenience
LinearCompartmentModel = common.sim.LinearCompartmentModel
SquareWavePulse = common.sim.SquareWavePulse
ViewModel = common.ViewModel


# ----------------------------------------------------
# Set up the simulation
# ----------------------------------------------------

initializeSimulation = () ->

    # ------------------------------------------------------
    # Simulation components
    # ------------------------------------------------------

    # Build a linear compartment model with 4 compartments
    sim = LinearCompartmentModel(10).R_a(10.0)

    # Build a square-wave pulse object (to connect to the compartment 0)
    pulse = SquareWavePulse().interval([1.0, 1.5])
                             .amplitude(25.0)
                             .I_stim(sim.compartments[0].I_ext)
                             .t(sim.t)

    # ------------------------------------------------------
    # Bind variables from the compartment simulations to the
    # view model and to each other
    # ------------------------------------------------------

    # Build a view model obj to manage KO bindings
    vm = new ViewModel()


    # Connect up the compartment model
    vm.inheritProperties(sim, ['t', 'v0', 'v1', 'v2', 'v3', 'I0', 'I1', 'I2', 'I3', 'R_a'])
    vm.inheritProperties(pulse, ['stimOn'])

    svgbind.bindMultiState({'#stimOff': false, '#stimOn': true}, vm.stimOn)

    # Set the html-based Knockout.js bindings in motion
    # This will allow templated 'data-bind' directives to automagically control the simulation / views
    ko.applyBindings(vm)

    # ------------------------------------------------------
    # Oscilloscopes!
    # ------------------------------------------------------

    # # Make an oscilloscope and attach it to the svg
    oscopes = []
    oscopes[0] = oscilloscope('#art svg', '#oscope1').data(-> [sim.t(), sim.v0()])
    oscopes[1] = oscilloscope('#art svg', '#oscope2').data(-> [sim.t(), sim.v1()])
    oscopes[2] = oscilloscope('#art svg', '#oscope3').data(-> [sim.t(), sim.v2()])

    # # Float a div over a rect in the svg
    util.floatOverRect('#art svg', '#propertiesRect', '#floaty')

    maxSimTime = 10.0
    for scope in oscopes
        scope.maxX = maxSimTime

    update = ->

        # Update the simulation
        sim.step()

        # Tell the oscilloscope to plot
        scope.plot() for scope in oscopes

        if sim.t() >= maxSimTime
            sim.reset()
            scope.reset() for scope in oscopes


    updateTimer = setInterval(update, 50)



# Main initialization function; triggered after the SVG doc is
# loaded
svgDocumentReady = (xml) ->

    # Attach the SVG to the DOM in the appropriate place
    importedNode = document.importNode(xml.documentElement, true)
    d3.select('#art').node().appendChild(importedNode)

    initializeSimulation()


$ ->
    # load the svg artwork and hook everything up
    d3.xml('svg/ap_propagation.svg', 'image/svg+xml', svgDocumentReady)

