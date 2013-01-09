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


class ApPropagation2 extends mcb80x.ViewModel

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
        @myelinatedSim = mcb80x.sim.MyelinatedLinearCompartmentModel(24, 4).C_m(0.9)
        @unmyelinatedSim = mcb80x.sim.LinearCompartmentModel(24)

        @sim = @myelinatedSim
        @sim.R_a(0.25)

        @pulseAmplitude = ko.observable(180.0)

        @setup()

    setup: ->

        # Build a square-wave pulse object (to connect to the compartment 0)
        @pulse = mcb80x.sim.SquareWavePulse().interval([1.0, 1.5])
                                 .I_stim(@sim.compartments[0].I_ext)
                                 .t(@sim.t)
        @pulse.amplitude = @pulseAmplitude

        # ------------------------------------------------------
        # Bind variables from the compartment simulations to the
        # view model and to each other
        # ------------------------------------------------------

        # Connect up the compartment model
        @inheritProperties(@sim)
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
        oscopeCompartment = @sim.compartments[19]
        @oscopes.push oscilloscope('#art svg', '#oscope1').data(=> [@sim.t(), oscopeCompartment.v()])
        # @oscopes[1] = oscilloscope('#art svg', '#oscope2').data(=> [@sim.t(), @sim.v1()])
        # @oscopes[2] = oscilloscope('#art svg', '#oscope3').data(=> [@sim.t(), @sim.v2()])

        # Float a div over a rect in the svg
        util.floatOverRect('#art svg', '#propertiesRect', '#floaty')

        @maxSimTime = 30.0 # ms
        for scope in @oscopes
            scope.maxX = @maxSimTime

        @iterations = 0
        @updateTimer = undefined

        @xvplot = d3.select('#XVPlot')
        @xvplot.attr('opacity', 0.0)
        xvbbox = @xvplot.node().getBBox()

        nCompartments = @sim.compartments.length
        @xScale = d3.scale.linear().domain([0, nCompartments]).range([xvbbox.x, xvbbox.x + xvbbox.width])
        @vScale = d3.scale.linear().domain([-80, 50]).range([xvbbox.y+xvbbox.height, xvbbox.y])

        console.log @nCompartments
        console.log xvbbox
        console.log @xScale(5)
        console.log @xScale(100)

        @xvLine = d3.svg.line()
            .interpolate('basis')
            .x((d, i) => @xScale(i))
            .y((d, i) => @vScale(d))

        @xvPath = @svg.append('path')
            .data([@I()])
            .attr('class', 'xv-line')
            .attr('d', @xvLine)


    play: ->
        update = =>

            # Update the simulation
            @sim.step()


            # Tell the oscilloscope to plot
            scope.plot() for scope in @oscopes

            @xvPath.data([@sim.v()]).attr('d', @xvLine)

            if @sim.t() >= @maxSimTime
                @sim.reset()
                scope.reset() for scope in @oscopes
                @iterations += 1

        @updateTimer = setInterval(update, 10)

    stop: ->
        clearInterval(@updateTimer) if @updateTimer


    myelinated: (v) ->
        if v?
            if v
                @sim = @myelinatedSim
            else
                @sim = @unmyelinatedSim

            @setup()
        else
            return (@sim is @myelinatedSim)

    # Main initialization function; triggered after the SVG doc is
    # loaded
    svgDocumentReady: (xml) ->

        # transition out the video if it's visible
        # d3.select('#video').transition().style('opacity', 0.0).duration(1000)

        # Attach the SVG to the DOM in the appropriate place
        importedNode = document.importNode(xml.documentElement, true)

        d3.select('#art').node().appendChild(importedNode)
        d3.select('#art').transition().style('opacity', 1.0).duration(1000)

        @svg = d3.select(importedNode)
        @svg.attr('width', '100%')
        @svg.attr('height', '100%')

        @init()


    show: ->
        console.log('showing hodghux')
        d3.xml('svg/ap_propagation2.svg', 'image/svg+xml', (xml) => @svgDocumentReady(xml))

    hide: ->
        @runSimulation = false
        d3.select('#art').transition().style('opacity', 0.0).duration(1000)


root = window ? exports
root.stages.approp2 = new ApPropagation2()
