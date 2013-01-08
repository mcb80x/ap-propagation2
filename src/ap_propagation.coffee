# ----------------------------------------------------
# Imports (using coffee-toaster directives)
# ----------------------------------------------------

#<< mcb80x/util
#<< mcb80x/bindings
#<< mcb80x/oscilloscope
#<< mcb80x/sim/linear_compartment
#<< mcb80x/properties
#<< mcb80x/sim/stim
#<< mcb80x/lesson_plan


class ApPropagation extends mcb80x.ViewModel

    constructor: ->
        @duration = ko.observable(10.0)

    # ----------------------------------------------------
    # Set up the simulation
    # ----------------------------------------------------

    init: ->

        # ------------------------------------------------------
        # Simulation components
        # ------------------------------------------------------

        # Build a linear compartment model with 4 compartments
        @sim = mcb80x.sim.LinearCompartmentModel(10).R_a(10.0)

        # Build a square-wave pulse object (to connect to the compartment 0)
        @pulse = mcb80x.sim.SquareWavePulse().interval([1.0, 1.5])
                                 .amplitude(25.0)
                                 .I_stim(@sim.compartments[0].I_ext)
                                 .t(@sim.t)

        # ------------------------------------------------------
        # Bind variables from the compartment simulations to the
        # view model and to each other
        # ------------------------------------------------------

        # Connect up the compartment model
        @inheritProperties(@sim, ['t', 'v0', 'v1', 'v2', 'v3', 'I0', 'I1', 'I2', 'I3', 'R_a'])
        @inheritProperties(@pulse, ['stimOn'])

        svgbind.bindMultiState({'#stimOff': false, '#stimOn': true}, @stimOn)

        # Set the html-based Knockout.js bindings in motion
        # This will allow templated 'data-bind' directives to automagically control the simulation / views
        ko.applyBindings(this)

        # ------------------------------------------------------
        # Oscilloscopes!
        # ------------------------------------------------------

        # # Make an oscilloscope and attach it to the svg
        @oscopes = []
        @oscopes[0] = oscilloscope('#art svg', '#oscope1').data(=> [@sim.t(), @sim.v0()])
        @oscopes[1] = oscilloscope('#art svg', '#oscope2').data(=> [@sim.t(), @sim.v1()])
        @oscopes[2] = oscilloscope('#art svg', '#oscope3').data(=> [@sim.t(), @sim.v2()])

        # # Float a div over a rect in the svg
        util.floatOverRect('#art svg', '#propertiesRect', '#floaty')

        @maxSimTime = 10.0 # ms
        for scope in @oscopes
            scope.maxX = @maxSimTime

        @iterations = 0
        @updateTimer = undefined

    play: ->
        update = =>

            # Update the simulation
            @sim.step()

            # Tell the oscilloscope to plot
            scope.plot() for scope in @oscopes

            if @sim.t() >= @maxSimTime
                @sim.reset()
                scope.reset() for scope in @oscopes
                @iterations += 1


        @updateTimer = setInterval(update, 50)

    stop: ->
        clearInterval(@updateTimer) if @updateTimer

    # Main initialization function; triggered after the SVG doc is
    # loaded
    svgDocumentReady: (xml) ->

        # transition out the video if it's visible
        # d3.select('#video').transition().style('opacity', 0.0).duration(1000)

        # Attach the SVG to the DOM in the appropriate place
        importedNode = document.importNode(xml.documentElement, true)
        d3.select('#art').node().appendChild(importedNode)
        d3.select('#art').transition().style('opacity', 1.0).duration(1000)

        @init()


    show: ->
        console.log('showing hodghux')
        d3.xml('svg/ap_propagation.svg', 'image/svg+xml', (xml) => @svgDocumentReady(xml))

    hide: ->
        @runSimulation = false
        d3.select('#art').transition().style('opacity', 0.0).duration(1000)


root = window ? exports
root.stages.approp = new ApPropagation()
