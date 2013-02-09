#<< mcb80x/lesson_plan
#<< ap_propagation2


# Script

scene('Action Potential Generation', 'ap_propagation2') ->

    interactive('The axon, with resistance only') ->
        stage 'approp2',
            myelinated: false
            propertiesVisible: false
            voltageClamped: false
            resistanceOnly: true
            R_a: 1.0

        soundtrack 'imhotep.mp3'
        duration 10

        show 'Axon', 'RecordingOscilloscope'

        play '*'

        line 'DR-100_0154.wav',
            "For now, let's set the membrane capacitance to zero....",
            ->
                wait 2000
                show 'Cm'
                wait 500
                show 'noCm'
                wait 3000
                show 'gatedChannel'
                wait 500
                show 'noGatedChannel'

        line 'DR-100_0156.mp3',
            "Now, we'll plot the voltage at every point along the axon",
            ->
                show 'XVGraph'

        line 'DR-100_0158.wav',
            "Now we'll give you a lever ....",
            ->
                set_property 'voltageClamped', true
                wait 7000
                show 'Stimulator'

        line 'DR-100_0160.wav',
            "Remember, ..."

        line 'DR-100_0162.wav',
            "Move the little 'v' knob ..."

        show 'nextButton'

        choice 'nextButton'

        hide 'nextButton'

        line 'DR-100_0165.wav',
            "Did you notice..."

        line 'DR-100_0166.wav',
            "This is a fundamental..."

        line 'DR-100_0167.wav',
            "It's not essential..."

        line 'DR-100_0168.wav',
            "If you'd like a quick refresher..."

        line 'DR-100_0169.wav',
            "Now let's give you a knob...",
            ->
                set_property 'propertiesVisible', true
                set_property 'R_a_knob', true


        line 'DR-100_0170.wav',
            "What will happen if we lower the axial resistance?"

        line 'DR-100_0173.wav',
            "Will the effect of the clamped voltage spead...",
            ->
                hide 'Q2A', 'Q2B', 'Q2C'
                show 'Q2'

        line 'DR-100_0174.wav',
            "a) Farther"

        show 'Q2A'

        line 'DR-100_0175.wav',
            "b) Less far"

        show 'Q2B'

        line 'DR-100_0176.wav',
            "or c) The same distance?"

        show 'Q2C'


        line 'DR-100_0177.wav',
            "OK, let's put it to the test"

        choice 'Q2'
        hide 'Q2'

        line 'DR-100_0178.wav',
            "That's right, when we lower the axial resistance...",

        line 'DR-100_0181.wav',
            "So far, we've been waving a magic wand.."

        hide 'Cm', 'noCm'
        set_property 'resistanceOnly', false

        line 'DR-100_0184.wav',
            "Play around with the voltage clamp again..."

        line 'DR-100_0185.wav',
            "Click next when you're ready to move on.",
            ->
                show 'nextButton'

        choice 'nextButton'
        hide 'nextButton'

        line 'DR-100_0187.wav',
            "Did you notice how ...",

        line 'DR-100_0189.wav',
            "OK, so now we're ready to start putting more of the pieces back together"

        line 'DR-100_0190.wav',
            "Let's return to a normal stimulating electrode",
            ->
                wait 2700
                set_property 'voltageClamped', false
                wait 2000
                hide 'noGatedChannel', 'gatedChannel'
                set_property 'stimCompartmentActive', true

        goal ->
            initial:
                action: ->
                    @stage.iterations = 0
                transition: ->
                    if @stage.iterations > 2
                        return 'continue'

        show 'nextButton'
        choice 'nextButton'

        line 'DR-100_0191.wav',
            "So now the chain reaction nature ..."

        line 'DR-100_0192.wav',
            "Stimulating an action potential causes a bubble..."

        line 'DR-100_0194.wav',
            "This bubble of depolarization in turn open voltage-gated ..."

        line 'DR-100_0195.wav',
            "OK, now everything is back in ..."

        line 'DR-100_0196.wav',
            "Let's make another prediction..."

        line 'DR-100_0198.wav',
            "What if instead we plotted..."

        line 'DR-100_0200.wav',
            "What would that waveform look like..."

        # todo re-record
        line 'DR-100_0203.wav',
            "Would the distance versus... most look like:",
            ->
                show 'Q3'

        line 'DR-100_0204.wav',
            "a) Basically the same shape",
            ->
                show 'Q3A'

        line 'DR-100_0205.wav',
            "b) similar to that plot, but flipped upside down",
            ->
                show 'Q3B'

        line 'DR-100_0206.wav',
            "c) Similar to that plot, but flipped left-right",
            ->
                show 'Q3C'

        line 'DR-100_0207.wav',
            "or d) a sin-wave, spanning the axon",
            ->
                show 'Q3D'

        choice 'Q3'

        line 'DR-100_0209.wav',
            "Let's put that to the test"

        wait 2000

        show 'nextButton'
        choice 'nextButton'

        line 'DR-100_0211.wav',
            "OK, so the correct answer is c) ..."

        line 'DR-100_0213.wav',
            "regions to the left..."

        # 214-219 stimulate in the middle


    interactive('Introducing action potential propagation') ->
        stage 'approp2',
            voltageGatedChannelsActive: true

        soundtrack 'imhotep.mp3'
        duration 10

        wait 50

        line 'DR-100_0124.wav',
            "Let's try and get some firsthand intuition for how the action potential propagates"

        wait 500

        line 'DR-100_0125.wav',
            "Let's consider a length of axon",
            ->
                show 'Axon'

        wait 1000

        line 'DR-100_0127.wav',
            "The cell body would be ...",
            ->
                show 'cellBodyArrowSign'
                wait 3000
                show 'targetArrowSign'

        wait 2000

        hide 'targetArrowSign', 'cellBodyArrowSign'
        line 'DR-100_0128.wav',
            "We'll give you an oscilloscope ...",
            ->
                show 'RecordingOscilloscope'


        line 'DR-100_0130.wav',
            "And we'll give you a stimulating ...",
            ->
                show 'Stimulator'

        wait 250
        show 'HodgkinAndHuxley'
        line 'DR-100_0131.wav',
            "This isn't far off from ..."
        hide 'HodgkinAndHuxley'

        line 'DR-100_0133.wav',
            "But first, let's get a flavor for ..."

        line 'DR-100_0134.wav',
            "In a moment, you'll ... but first, let's make a prediction"


        # Question 1!
        hide 'Q1A', 'Q1B', 'Q1C', 'Q1D', 'Q1ChooseOne'
        show 'Q1'

        line 'DR-100_0135.wav',
            "Will we see..."

        show 'Q1A'
        line 'DR-100_0137.wav',
            "a ..."

        show 'Q1B'
        line 'DR-100_0138.wav',
            "b ..."

        show 'Q1C'
        line 'DR-100_0139.wav',
            "c ..."

        show 'Q1D'
        line 'DR-100_0140.wav',
            "d ..."

        show 'Q1ChooseOne'

        choice 'Q1'

        hide 'Q1'
        wait 500

        line 'DR-100_0141.wav',
            "As before, we've slowed down..."

        play '*'

        line 'DR-100_0142.wav',
            "Now press the stimulator button and test your prediction."


        goal ->
            initial:
                transition: ->
                    if @stage.iterations >= 1
                        return 'continue'
            # hint1:
            #     action: ->
            #         line 'glass0.mp3', "This message will pop up after 10 seconds, just ignore it"

            #     transition: -> 'initial'

        wait 2000

        line 'DR-100_0143.wav',
            "Excellent..."

        line 'DR-100_0144.wav',
            "So (b) was the right answer..."

    interactive('Comparing action potential propagation to wires') ->
        stage 'coming_soon.svg'
        duration 5

        line 'DR-100_0145.wav',
            "If you're used to thinking about wires..."

        line 'DR-100_0146.wav',
            "Afterall ..."

    interactive('Axon equivalent circuit diagram') ->
        stage 'axon_equivalent_circuit.svg'
        duration 5

        line 'DR-100_0147.wav',
            "Equivalent circuit looks more like this",
            ->
                show 'membraneCircuit'
                show 'extracellularResistance'
                show 'intracellularResistance'


        line 'DR-100_0149.wav',
            "The axoplasm running down the middle...",
            -> show 'Raxial'

        line 'DR-100_0150.wav',
            "The membrane acts like a capacitor",
            -> show 'Cm'

        line 'DR-100_0151.wav',
            "channels..."
            ->
                show 'Em'
                wait 500
                show 'Rm'

        line 'DR-100_0152.wav',
            "This same motif is repeated ....",
            ->
                wait 500
                show 'circuit2'
                wait 250
                show 'circuit3'
                wait 250
                show 'circuit4'
                wait 250
                show 'circuit5'

        line 'DR-100_0153.wav',
            "Let's go back to our test axon"


