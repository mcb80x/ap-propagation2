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

        # Some knockout.js bindings to marionette the interactive
        @duration = ko.observable(10.0)
        @stimCompIndex = ko.observable(0)
        @voltageClamped = ko.observable(false)
        @clampVoltage = ko.observable(-65.0)

        @pulseAmplitude = ko.observable(180.0)
        @myelinated = ko.observable(0)

        @XVPlotVRange = [-80, 50]

        # Observables to store answers to questions
        @Q1 = ko.observable('none')
        @Q2 = ko.observable('none')


    # ----------------------------------------------------
    # Set up the simulation
    # ----------------------------------------------------

    init: ->

        # ------------------------------------------------------
        # Simulation components
        # ------------------------------------------------------

        # Build a linear compartment model with 4 compartments
        @myelinatedSim = mcb80x.sim.MyelinatedLinearCompartmentModel(24, 4).C_m(0.9)
        @unmyelinatedSim = mcb80x.sim.LinearCompartmentModel(36).C_m(1.1)

        @sim = @unmyelinatedSim
        @sim.R_a(0.25)


        # Oscilloscope
        @oscopes = []
        @oscopes.push oscilloscope('#art svg', '#oscope1')


        # Properties
        #util.floatOverRect('#art svg', '#propertiesRect', '#floaty')

        # Myelin
        svgbind.bindVisible('#myelin', @myelinated)
        @myelinated.subscribe( (v) => @myelinate(v))


        # XV Plot
        @xvPath = d3.select('#XVGraph').append('path')

        # Voltage Clamp
        svgbind.bindSlider('#vKnob',
                            '#XVPlot',
                            'v',
                            @clampVoltage,
                            d3.scale.linear().domain([0,1]).range(@XVPlotVRange))

        svgbind.bindVisible('#vKnob', @voltageClamped)
        @voltageClamped.subscribe( => @stop(); @setup(); @play() )

        svgbind.bindMultiState({'#VoltageClamp':true, '#CurrentStimulator':false}, @voltageClamped)


        # Stimulator
        # Build a square-wave pulse object (to connect to the compartment 0)
        stimCompartment = @sim.compartments[@stimCompIndex()]
        @pulse = mcb80x.sim.CurrentPulse()
                                 .I_stim(stimCompartment.I_ext)
                                 .t(@sim.t)

        @pulse.amplitude = @pulseAmplitude
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

        @setup()


    setup: ->

        # ------------------------------------------------------
        # Bind variables from the compartment simulations to the
        # view model and to each other
        # ------------------------------------------------------

        # Connect up the compartment model
        @inheritProperties(@sim)

        stimCompartment = @sim.compartments[@stimCompIndex()]

        # stimCompartment.voltageClamped(@voltageClamped())


        if @voltageClamped()
            stimCompartment.voltageClamped(true)
            stimCompartment.clampVoltage(@clampVoltage)
            console.log('applying voltage clamp')

        else
            stimCompartment.voltageClamped(false)
            console.log('clearing voltage clamp: ' + stimCompartment.voltageClamped())

            @pulse.I_stim(stimCompartment.I_ext)
            # stimCompartment.I_ext(@pulse.I_stim)


        # Set the html-based Knockout.js bindings in motion
        # This will allow templated 'data-bind' directives to automagically control the simulation / views
        ko.applyBindings(this)

        # ------------------------------------------------------
        # Oscilloscopes!
        # ------------------------------------------------------
        oscopeCompartment = @sim.compartments[32]
        @oscopes[0].data(=> [@sim.t(), oscopeCompartment.v()])

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


    myelinate: (v) ->

        @stop()

        if v
            @sim = @myelinatedSim
            @sim.R_a(0.35)
            @sim.C_m(0.5)
            $('#CSlider').slider('enable')

        else
            @sim = @unmyelinatedSim
            @sim.R_a(0.45)
            @sim.C_m(1.1)
            $('#CSlider').slider('disable')

        @setup()
        @play()




root = window ? exports
root.stages.approp2 = new ApPropagation2()
