# ----------------------------------------------------
# Imports (using coffee-toaster directives)
# ----------------------------------------------------

#<< mcb80x/util
#<< mcb80x/bindings
#<< mcb80x/oscilloscope
#<< mcb80x/sim/linear_compartment
#<< mcb80x/interactive_svg
#<< mcb80x/sim/stim
#<< mcb80x/lesson_plan
#<< mcb80x/timeline


class ApPropagation2 extends mcb80x.InteractiveSVG

    constructor: ->

        # Defer SVG marionetting stuff to base class
        super('svg/ap_propagation2.svg')

        # Some knockout.js custom bindings to marionette the interactive

        # what kind of simulation
        @myelinated = ko.observable false
        @resistanceOnly = ko.observable false
        @passiveOnly = ko.observable false
        @voltageClamped = ko.observable false
        @activeStimCompartmentOnly = ko.observable false

        @duration = ko.observable 10.0 # an estimate
        @stimCompartmentIndex = ko.observable 0 # which compartment to stimulate

        @clampVoltage = ko.observable -65.0
        @pulseAmplitude = ko.observable 180.0

        @XVPlotVRange = [-80, 50]

        # show or hide the properties panel
        @propertiesVisible = ko.observable false

        # Properties to store answers to questions
        @Q1 = ko.observable 'none'
        @Q2 = ko.observable 'none'
        @Q3 = ko.observable 'none'

        @nextButton = ko.observable false
        @R_a_knob = ko.observable false
        @C_m_knob = ko.observable false

        # ------------------------------------------------------
        # Simulation components
        # ------------------------------------------------------

        @sim = undefined
        @pulse = undefined

        @oscopes = []


    connectStimulator: ->

        # Stimulator

        # Build a square-wave pulse object (to connect to the compartment 0)
        stimCompartment = @sim.compartments[@stimCompartmentIndex()]
        @pulse.I_stim(stimCompartment.I_ext)

        # attach the voltage clamp stimulator as well; only one stimulator will
        # actually be active at a time
        stimCompartment.voltageClamped(@voltageClamped)
        stimCompartment.clampVoltage(@clampVoltage)


    initInteractive: ->

        # ----------------------------------------------------
        # Set up the simulation
        # ----------------------------------------------------

        # Build a linear compartment model with 31 compartments and
        # 6 "nodes".  In the case of an unmyelinated simulation, the
        # node designation has no meaning
        @sim = mcb80x.sim.MyelinatedLinearCompartmentModel(31, 6)


        @updateSimulationParameters()

        @myelinated.subscribe(=> @updateSimulationParameters())
        @voltageClamped.subscribe(=> @updateSimulationParameters())
        @passiveOnly.subscribe(=> @updateSimulationParameters())
        @resistanceOnly.subscribe(=> @updateSimulationParameters())
        @activeStimCompartmentOnly.subscribe(=> @updateSimulationParameters())

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

        svgbind.bindMultipleChoice(
            '#Q2A': 'a'
            '#Q2B': 'b'
            '#Q2C': 'c'
            @Q2
        )

        svgbind.bindMultipleChoice(
            '#Q3A': 'a'
            '#Q3B': 'b'
            '#Q3C': 'c'
            '#Q3D': 'd',
            @Q3
        )

        svgbind.bindAsMomentaryButton('#nextButtonOn', '#nextButtonOff', @nextButton)

        # Set the html-based Knockout.js bindings in motion
        # This will allow templated 'data-bind' directives to automagically control the simulation / views

        ko.applyBindings(this, $('#interactive')[0])

        # ------------------------------------------------------
        # Plotting
        # ------------------------------------------------------

        # Oscilloscopes
        @oscopes = []
        @oscopes.push oscilloscope('#art svg', '#oscope1')

        oscopeCompartment = @sim.compartments[24]
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


    updateSimulationParameters: ->
        console.log('updating simulation')

        if @myelinated()
            @sim.passiveInternodes(true)
            @sim.passiveNodes(false)
            @sim.passiveFirstNode(false)
            @sim.R_a(0.1)
            @sim.C_node(1.0)
            @sim.C_internode(0.4)
            @sim.g_L_internode(0.1)
            @sim.g_L_node(0.3)
        else
            @sim.passiveFirstNode(false)
            @sim.passiveNodes(false)
            @sim.passiveInternodes(false)
            @sim.R_a(0.25)
            @sim.C_node(1.0)
            @sim.C_internode(@sim.C_node())
            @sim.g_L_internode(0.3)
            @sim.g_L_node(0.3)

        if @resistanceOnly()
            @sim.passiveInternodes(true)
            @sim.passiveNodes(true)
            @sim.passiveFirstNode(true)
            @sim.resistanceOnly(true)
            @sim.R_a(1.5)
            @sim.g_L_internode(0.3)
            @sim.g_L_node(0.3)

        else if @passiveOnly()
            @sim.passiveInternodes(true)
            @sim.passiveNodes(true)
            @sim.passiveFirstNode(true)
            @sim.g_L_internode(0.3)
            @sim.g_L_node(0.3)

        else if @activeStimCompartmentOnly()
            @sim.passiveInternodes(true)
            @sim.passiveNodes(true)
            @sim.passiveFirstNode(false)
            @sim.g_L_internode(0.3)
            @sim.g_L_node(0.3)



    show: ->
        dfrd = super()

        return dfrd.then(=> @initInteractive())


    hide: (cb) ->
        @propertiesVisible(false)
        super(cb)

    play: ->

        @iterations = 0
        update = =>

            # Update the simulation
            @sim.step()

            # Tell the oscilloscope to plot
            scope.plot() for scope in @oscopes

            @xvPath.data([@sim.v()]).attr('d', @xvLine)


        @updateTimer = setInterval(update, 10)

    reset: ->
        # @stop()
        @oscopes = []
        # @init()

    stop: ->
        dfrd = $.Deferred()

        stopit = =>
            clearInterval(@updateTimer) if @updateTimer
            @sim.reset() if (@sim and @sim.reset?)
            scope.reset() for scope in @oscopes
            dfrd.resolve()

        setTimeout(stopit, 0)

        return dfrd



root = window ? exports
root.stages.approp2 = () -> new ApPropagation2()
