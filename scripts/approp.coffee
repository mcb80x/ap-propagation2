# Script

console.log('running script')

scene('Action Potential Generation', 'action_potential_propagation_p1') ->

    # video('Getting from point A to point B') ->
    #     mp4 '/video/intro_bit2.mp4'
    #     m4v '/video/intro_bit2.m4v'

    interactive('Introducing action potential propagation') ->
        stage 'approp2',
            voltageGatedChannelsActive: true

        # soundtrack 'neurunclomist_gathering.mp3'
        soundtrack 'otomaton.mp3'
        duration 10

        wait 50

        line 'DR-100_0124.mp3',
            "Let's try and get some firsthand intuition for how the action potential propagates"

        wait 500

        line 'DR-100_0125.mp3',
            "Let's consider a length of axon",
            ->
                show 'Axon'

        wait 1000

        line 'DR-100_0127.mp3',
            "The cell body would be ...",
            ->
                show 'cellBodyArrowSign'
                wait 3000
                show 'targetArrowSign'

        wait 2000

        hide 'targetArrowSign', 'cellBodyArrowSign'
        line 'DR-100_0128.mp3',
            "We'll give you an oscilloscope ...",
            ->
                show 'RecordingOscilloscope'


        line 'DR-100_0130.mp3',
            "And we'll give you a stimulating ...",
            ->
                show 'Stimulator'

        # wait 250
        # show 'HodgkinAndHuxley'
        # line 'DR-100_0131.mp3',
        #     "This isn't far off from ..."
        # hide 'HodgkinAndHuxley'

        # line 'DR-100_0133.mp3',
        #     "But first, let's get a flavor for ..."

        # line 'DR-100_0134.mp3',
        #     "In a moment, you'll ... but first, let's make a prediction"


        # # Question 1!
        # hide 'Q1A', 'Q1B', 'Q1C', 'Q1D', 'Q1ChooseOne'
        # show 'Q1'

        # line 'DR-100_0135.mp3',
        #     "Will we see..."

        # show 'Q1A'
        # line 'DR-100_0137.mp3',
        #     "a ..."

        # show 'Q1B'
        # line 'DR-100_0138.mp3',
        #     "b ..."

        # show 'Q1C'
        # line 'DR-100_0139.mp3',
        #     "c ..."

        # show 'Q1D'
        # line 'DR-100_0140.mp3',
        #     "d ..."

        # show 'Q1ChooseOne'

        # choice 'Q1'

        # hide 'Q1'
        # wait 500

        # line 'DR-100_0141.mp3',
        #     "As before, we've slowed down..."

        play '*'

        line 'DR-100_0142.mp3',
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

        line 'DR-100_0143.mp3',
            "Excellent..."

        line 'DR-100_0144.mp3',
            "So (b) was the right answer..."

    interactive('Comparing action potential propagation to wires') ->
        stage 'coming_soon.svg'
        duration 5

        line 'DR-100_0145.mp3',
            "If you're used to thinking about wires..."

        line 'DR-100_0146.mp3',
            "Afterall ..."

    interactive('Axon equivalent circuit diagram') ->
        stage 'axon_equivalent_circuit.svg'
        duration 5

        line 'DR-100_0147.mp3',
            "Equivalent circuit looks more like this",
            ->
                show 'membraneCircuit'
                show 'extracellularResistance'
                show 'intracellularResistance'


        line 'DR-100_0149.mp3',
            "The axoplasm running down the middle...",
            -> show 'Raxial'

        line 'DR-100_0150.mp3',
            "The membrane acts like a capacitor",
            -> show 'Cm'

        line 'DR-100_0151.mp3',
            "channels..."
            ->
                show 'Em'
                wait 500
                show 'Rm'

        line 'DR-100_0152.mp3',
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

        line 'DR-100_0153.mp3',
            "Let's go back to our test axon"


    interactive('The axon, with resistance only') ->
        stage 'approp2',
            myelinated: false
            propertiesVisible: false
            voltageClamped: false
            resistanceOnly: true
            R_a: 1.0

        soundtrack 'otomaton.mp3'
        duration 10

        show 'Axon', 'RecordingOscilloscope'

        play '*'

        line 'DR-100_0154.mp3',
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

        line 'DR-100_0158.mp3',
            "Now we'll give you a lever ....",
            ->
                set_property 'voltageClamped', true
                wait 7000
                show 'Stimulator'

        line 'DR-100_0160.mp3',
            "Remember, ..."

        line 'DR-100_0162.mp3',
            "Move the little 'v' knob ..."

        show 'nextButton'

        choice 'nextButton'

        hide 'nextButton'

        line 'DR-100_0165.mp3',
            "Did you notice..."

        line 'DR-100_0166.mp3',
            "This is a fundamental..."

        # line 'DR-100_0167.mp3',
        #     "It's not essential..."

        # line 'DR-100_0168.mp3',
        #     "If you'd like a quick refresher..."

        line 'DR-100_0169.mp3',
            "Now let's give you a knob...",
            ->
                set_property 'propertiesVisible', true
                set_property 'R_a_knob', true


        line 'DR-100_0170.mp3',
            "What will happen if we lower the axial resistance?"

        line 'DR-100_0173.mp3',
            "Will the effect of the clamped voltage spead...",
            ->
                hide 'Q2A', 'Q2B', 'Q2C', 'Q2ChooseOne'
                show 'Q2'

        show 'Q2A'
        line 'DR-100_0174.mp3',
            "a) Farther"

        show 'Q2B'
        line 'DR-100_0175.mp3',
            "b) Less far"


        show 'Q2C'
        line 'DR-100_0176.mp3',
            "or c) The same distance?"


        line 'DR-100_0177.mp3',
            "OK, let's put it to the test"

        choice 'Q2'
        hide 'Q2'

        line 'DR-100_0178.mp3',
            "That's right, when we lower the axial resistance...",

        line 'DR-100_0181.mp3',
            "So far, we've been waving a magic wand.."

        hide 'Cm', 'noCm'
        set_property 'resistanceOnly', false

        line 'DR-100_0184.mp3',
            "Play around with the voltage clamp again..."

        line 'DR-100_0185.mp3',
            "Click next when you're ready to move on.",

        show 'nextButton'

        choice 'nextButton'

        hide 'nextButton'

        line 'DR-100_0187.mp3',
            "Did you notice how ...",

        line 'DR-100_0189.mp3',
            "OK, so now we're ready to start putting more of the pieces back together"

        stop_and_reset '*'

        line 'DR-100_0190.mp3',
            "Let's return to a normal stimulating electrode",
            ->
                wait 2700
                set_property 'voltageClamped', false
                wait 2000
                hide 'noGatedChannel', 'gatedChannel'
                set_property 'myelinated', false
                set_property 'passiveOnly', false
                set_property 'activeStimCompartmentOnly', true

        play '*'

        # goal ->
        #     initial:
        #         action: ->
        #             @stage.iterations = 0
        #         transition: ->
        #             if @stage.iterations > 2
        #                 return 'continue'

        show 'nextButton'
        choice 'nextButton'
        hide 'nextButton'

        line 'DR-100_0191.mp3',
            "So now the chain reaction nature ..."

        line 'DR-100_0192.mp3',
            "Stimulating an action potential causes a bubble..."

        line 'DR-100_0194.mp3',
            "This bubble of depolarization in turn open voltage-gated ..."

        set_property 'propertiesVisible', false

        line 'DR-100_0195.mp3',
            "OK, now everything is back in ..."

        stop_and_reset '*'

        set_property 'activeStimCompartmentOnly', false


        line 'DR-100_0196.mp3',
            "Let's make another prediction..."

        line 'DR-100_0198.mp3',
            "What if instead we plotted..."

        line 'DR-100_0200.mp3',
            "What would that waveform look like..."

        # todo re-record
        line 'DR-100_0203.mp3',
            "Would the distance versus... most look like:",
            ->
                hide 'Q3A', 'Q3B', 'Q3C', 'Q3D', 'Q3ChooseOne'
                show 'Q3'

        line 'DR-100_0204.mp3',
            "a) Basically the same shape",
            ->
                show 'Q3A'

        line 'DR-100_0205.mp3',
            "b) similar to that plot, but flipped upside down",
            ->
                show 'Q3B'

        line 'DR-100_0206.mp3',
            "c) Similar to that plot, but flipped left-right",
            ->
                show 'Q3C'

        line 'DR-100_0207.mp3',
            "or d) a sin-wave, spanning the axon",
            ->
                show 'Q3D'

        choice 'Q3'

        hide 'Q3'

        play '*'

        line 'DR-100_0209.mp3',
            "Let's put that to the test"

        wait 2000

        show 'nextButton'
        choice 'nextButton'
        hide 'nextButton'

        line 'DR-100_0211.mp3',
            "OK, so the correct answer is c) ..."

        line 'DR-100_0213.mp3',
            "regions to the left..."

    # video('APP firsthand') ->
    #     mp4 '/video/worms_etc.mp4'

        # 214-219 stimulate in the middle
