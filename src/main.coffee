#<< mcb80x/timeline
#<< script

$ ->
	console.log('starting...')
	t = new mcb80x.Timeline('#timeline', scenes.ap_propagation2)
	scenes.ap_propagation2.run()
