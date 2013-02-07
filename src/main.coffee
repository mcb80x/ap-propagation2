#<< mcb80x/timeline
#<< mcb80x/lesson_plan
#<< ap_propagation2


# Script

scene('Action Potential Generation', 'ap_propagation2') ->

    interactive('Basic action walk-through') ->
        stage 'approp2'
        soundtrack 'imhotep.mp3'
        duration 10

        wait 50

        line 'DR-100_0124.wav',
            "Let's try and get some firsthand intuition for how the action potential propagates"

        wait 500

        line 'DR-100_0125.wav',
            "Let's consider a length of axon"

        show 'Axon'
        wait 1000

        show 'cellBodyArrowSign'

        line 'DR-100_0127.wav',
            "The cell body would be ..."

        show 'targetArrowSign'
        wait 2000

        show 'RecordingOscilloscope'
        hide 'targetArrowSign', 'cellBodyArrowSign'
        line 'DR-100_0128.wav',
            "We'll give you an oscilloscope ..."


        show 'Stimulator'
        line 'DR-100_0130.wav',
            "And we'll give you a stimulating ..."

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

$ ->

	t = new mcb80x.Timeline('#timeline', scenes.ap_propagation2)
	scenes.ap_propagation2.run()
