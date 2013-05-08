

scene('Giant Axons', 'approp3') ->

     interactive('Axon equivalent circuit diagram') ->
        stage 'axon_equivalent_circuit.svg'
        duration 20

        line 'DR-100_0147.mp3',
            "Equivalent circuit looks more like this"

        show 'membraneCircuit', 'extracellularResistance',
             'intracellularResistance'


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