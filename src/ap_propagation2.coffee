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


class ApPropagation2 extends mcb80x.InteractiveSVG

    constructor: ->

        # Defer SVG marionetting stuff to base class
        super('svg/ap_propagation2.svg')

        # Some knockout.js custom bindings to marionette the interactive

        # what kind of simulation
        @myelinated = @prop false
        @resistanceOnly = @prop false
        @passiveOnly = @prop false
        @voltageClamped = @prop false

        @duration = @prop 10.0 # an estimate
        @stimCompartmentIndex = @prop 0 # which compartment to stimulate

        @clampVoltage = @prop -65.0
        @pulseAmplitude = @prop 180.0

        @XVPlotVRange = [-80, 50]

        # show or hide the properties panel
        @propertiesVisible = @prop false

        # Properties to store answers to questions
        @Q1 = @prop 'none'
        @Q2 = @prop 'none'

        # ------------------------------------------------------
        # Simulation components
        # ------------------------------------------------------

        @sim = undefined
        @pulse = undefined

    connectStimulator: ->

        # Stimulator

        # Build a square-wave pulse object (to connect to the compartment 0)
        stimCompartment = @sim.compartments[@stimCompartmentIndex()]
        @pulse.I_stim(stimCompartment.I_ext)

        # attach the voltage clamp stimulator as well; only one stimulator will
        # actually be active at a time
        stimCompartment.voltageClamped(@voltageClamped)
        stimCompartment.clampVoltage(@clampVoltage)


    init: ->

        # ----------------------------------------------------
        # Set up the simulation
        # ----------------------------------------------------

        # Build a linear compartment model with 31 compartments and
        # 6 "nodes".  In the case of an unmyelinated simulation, the
        # node designation has no meaning
        @sim = mcb80x.sim.MyelinatedLinearCompartmentModel(31, 6)

        @sim.R_a(0.25)
        @sim.C_node(1.0)
        @sim.C_internode(0.7)

        if @myelinated()
            @sim.passiveInternodes(true)
        else
            @sim.passiveInternodes(false)


        if @resistanceOnly()
            @sim.passiveInternodes(true)
            @sim.passiveNodes(true)
            @sim.C_node(0.0)
            @sim.C_internode(0.0)

        else if @passiveOnly()
            @sim.passiveInternodes(true)
            @sim.passiveNodes(true)


        @pulse = mcb80x.sim.CurrentPulse().t(@sim.t)
        @pulse.amplitude = @pulseAmplitude

        @connectStimulator()


        # Take on all of the properties from the sim object
        # allowing them to be accessed as properties on this object
        @inheritProperties(@sim)


        # ----------------------------------------------------
        # Set up UI elements
        # ----------------------------------------------------

        # Oscilloscope

        # Properties panel
        util.floatOverRect('#art svg', '#propertiesRect', '#floaty')

        # Myelin
        svgbind.bindVisible('#myelin', @myelinated)

        # XV Plot
        @xvPath = d3.select('#XVGraph').append('path')

        # Voltage Clamp
        svgbind.bindSlider('#vKnob',
                            '#XVPlot',
                            'v',
                            @clampVoltage,
                            d3.scale.linear().domain([0,1]).range(@XVPlotVRange))

        svgbind.bindVisible('#vKnob', @voltageClamped)
        # @voltageClamped.subscribe( => @stop(); @setup(); @play() )

        svgbind.bindMultiState({'#VoltageClamp':true, '#CurrentStimulator':false}, @voltageClamped)



        @inheritProperties(@pulse, ['stimOn'])
        svgbind.bindAsMomentaryButton('#stimOn', '#stimOff', @stimOn)

        @stimOn.subscribe((v) =>
            if v
                @iterations += 1
        )


        # Questions
        svgbind.bindMultipleChoice(
            '#Q1A': 'a'
            '#Q1B': 'b'
            '#Q1C': 'c'
            '#Q1D': 'd',
            @Q1
        )

        # Set the html-based Knockout.js bindings in motion
        # This will allow templated 'data-bind' directives to automagically control the simulation / views
        ko.applyBindings(this)

        # ------------------------------------------------------
        # Plotting
        # ------------------------------------------------------

        # Oscilloscopes
        @oscopes = []
        @oscopes.push oscilloscope('#art svg', '#oscope1')

        oscopeCompartment = @sim.compartments[25]
        @oscopes[0].data(=> [@sim.t(), oscopeCompartment.v()])

        @maxSimTime = 30.0 # ms
        for scope in @oscopes
            scope.maxX = @maxSimTime

        @iterations = 0
        @updateTimer = undefined

        # Distance vs. Voltage Plot
        @xvplot = d3.select('#XVPlot')
        @xvplot.attr('opacity', 0.0)
        xvbbox = @xvplot.node().getBBox()

        nCompartments = @sim.compartments.length
        @xScale = d3.scale.linear().domain([0, nCompartments]).range([xvbbox.x, xvbbox.x + xvbbox.width])
        @vScale = d3.scale.linear().domain(@XVPlotVRange).range([xvbbox.y+xvbbox.height, xvbbox.y])


        @xvLine = d3.svg.line()
            .interpolate('basis')
            .x((d, i) => @xScale(i))
            .y((d, i) => @vScale(d))

        @xvPath.data([@I()])
            .attr('class', 'xv-line')
            .attr('d', @xvLine)


    play: ->

        @iterations = 0
        update = =>

            # Update the simulation
            @sim.step()

            # Tell the oscilloscope to plot
            scope.plot() for scope in @oscopes

            @xvPath.data([@sim.v()]).attr('d', @xvLine)


        @updateTimer = setInterval(update, 10)

    stop: ->
        clearInterval(@updateTimer) if @updateTimer
        @sim.reset()
        scope.reset() for scope in @oscopes




root = window ? exports
root.stages.approp2 = () -> new ApPropagation2()
