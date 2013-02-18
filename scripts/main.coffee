
$ ->
	# Grab a reference to the APP part 1 scene (built in the script)
	thisScene = window.scenes['action_potential_propagation_p1']

	# Create a new timeline object, and associate it with the scene
	timeline = new mcb80x.Timeline('#timeline-controls', thisScene)


	# set the scene in motion
	thisScene.run()
