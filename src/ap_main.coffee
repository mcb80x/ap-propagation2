# ----------------------------------------------------
# Imports (using coffee-toaster directives)
# ----------------------------------------------------

root = window ? exports

#<< common/bindings
b = root.bindings

#<< common/oscilloscope

#<< common/sim/linear_compartment
LinearCompartmentModel = root.LinearCompartmentModel

#<< common/sim/stim
SquareWavePulse = root.SquareWavePulse

#<< common/util
util = root.util



# ----------------------------------------------------
# Set up the simulation
# ----------------------------------------------------

initializeSimulation = () ->

    # ------------------------------------------------------
    # Simulation components
    # ------------------------------------------------------

    # Build a linear compartment model with 4 compartments
    sim = new LinearCompartmentModel(10)

    # Build a square-wave pulse object (to connect to the compartment 0)
    pulse = new SquareWavePulse([0.0, 3.0], 15.0)


    # ------------------------------------------------------
    # Bind variables from the compartment simulations to the
    # view model and to each other
    # ------------------------------------------------------

    # Build a view model obj to manage KO bindings
    viewModel = {}


    # Connect up the compartment model
    b.exposeOutputBindings(sim, ['t', 'v0', 'v1', 'v2', 'v3', 'I0', 'I1', 'I2', 'I3'], viewModel)
    b.exposeInputBindings(sim, ['R_a'], viewModel)
    #b.bindInput(sim, 'R_a', viewModel, 'R_a', -> alert('blah'))

    # Connect up the stimulator
    b.bindOutput(pulse, 'I_stim', viewModel, 'I_stim')
    b.bindInput(pulse, 't', viewModel, 't', -> pulse.update())
    b.bindInput(sim.compartments[0], 'I_ext', viewModel, 'I_stim')


    # Set the html-based Knockout.js bindings in motion
    # This will allow templated 'data-bind' directives to automagically control the simulation / views
    ko.applyBindings(viewModel)

    # ------------------------------------------------------
    # Oscilloscopes!
    # ------------------------------------------------------

    # # Make an oscilloscope and attach it to the svg
    oscopes = []
    oscopes[0] = oscilloscope('#art svg', '#oscope1').data(-> [sim.t, sim.v1])
    oscopes[1] = oscilloscope('#art svg', '#oscope2').data(-> [sim.t, sim.v2])
    oscopes[2] = oscilloscope('#art svg', '#oscope3').data(-> [sim.t, sim.v3])

    # # Float a div over a rect in the svg
    util.floatOverRect('#art svg', '#propertiesRect', '#floaty')

    maxSimTime = 10.0
    for scope in oscopes
        scope.maxX = maxSimTime

    update = ->

        # Update the simulation
        sim.step()

        # update the bindings
        b.update()

        # Tell the oscilloscope to plot
        scope.plot() for scope in oscopes

        if sim.t >= maxSimTime
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

