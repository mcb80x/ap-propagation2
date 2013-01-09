(function() {

  scene('Action Potential Generation', 'ap_propagation2')(function() {
    return interactive('Basic action walk-through')(function() {
      stage('approp2');
      duration(10);
      wait(500);
      line('ap_line1', "We're now going to let the simulation run for three iterations.  Of course, more sophisticated scripting is also possible", {
        'NaChannelVisible': true,
        'KChannelVisible': false
      });
      play('beginning');
      goal(function() {
        return {
          initial: {
            transition: function() {
              if (this.stage.iterations >= 30) {
                return 'continue';
              }
            }
          },
          hint1: {
            action: function() {
              return line('hint1', "This message will pop up after 10 seconds, just ignore it");
            },
            transition: function() {
              return 'initial';
            }
          }
        };
      });
      return line('ap_line1', "That's it!");
    });
  });

  $(function() {
    var t;
    t = new mcb80x.Timeline('#timeline', scenes.ap_propagation2);
    return scenes.ap_propagation2.run();
  });

}).call(this);
