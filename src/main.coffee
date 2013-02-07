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


        line 'DR-100_0127.wav',
            "The cell body would be ..."

        line 'DR-100_0128.wav',
            "We'll give you an oscilloscope ..."

        show 'RecordingOscilloscope'


        line 'DR-100_0130.wav',
            "And we'll give you a stimulating ..."

        show 'Stimulator'

        line 'DR-100_0131.wav',
            "This isn't far off from ..."

        line 'DR-100_0133.wav',
            "But first, let's get a flavor for ..."

        line 'DR-100_0134.wav',
            "In a moment, you'll ... but first, let's make a prediction"

        line 'DR-100_0135.wav',
            "Will we see..."

        # Question 1!
        hide 'Q1A', 'Q1B', 'Q1C', 'Q1D'
        show 'Q1'


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

        line 'DR-100_0141.wav',
            "As before, we've slowed down..."


        choice 'Q1'

        hide 'Q1'

        line 'DR-100_0142.wav',
            "Now press the stimulator button and test your prediction."




        play '*'

        goal ->
            initial:
                transition: ->
                    if @stage.iterations >= 1
                        return 'continue'
            hint1:
                action: ->
                    line 'glass0.mp3', "This message will pop up after 10 seconds, just ignore it"

                transition: -> 'initial'

        line 'glass0.mp3',
            "That's it!"


$ ->

	t = new mcb80x.Timeline('#timeline', scenes.ap_propagation2)
	scenes.ap_propagation2.run()
