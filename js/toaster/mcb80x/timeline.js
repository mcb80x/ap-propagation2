(function() {

  mcb80x.Timeline = (function() {

    function Timeline(selector, scene) {
      var beat, duration, segId, segment, _i, _len, _ref,
        _this = this;
      this.scene = scene;
      this.orderedSegments = [];
      this.segmentLookup = {};
      this.div = d3.select(selector);
      this.scene.currentTime.subscribe(function(v) {
        return _this.update(_this.scene.currentSegment(), v);
      });
      this.svg = this.div.append('svg').attr('id', 'timeline-svg');
      this.bgRect = this.svg.append('rect').attr('width', '100%').attr('height', '100%').attr('class', 'timeline-background-rect');
      this.progressbar = this.svg.append('rect').attr('width', 0.0).attr('height', '30%').attr('x', '0').attr('y', '35%').attr('class', 'timeline-progressbar');
      this.orderedSegments = [];
      this.segmentLookup = {};
      _ref = this.scene.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        beat = _ref[_i];
        console.log(beat);
        duration = 1.0;
        if (beat.duration.subscribe != null) {
          beat.duration.subscribe(function() {
            return _this.setupTiming();
          });
        } else {
          duration = beat.duration();
        }
        segId = beat.elementId;
        segment = {
          segId: segId,
          title: segId,
          duration: duration
        };
        console.log(segment);
        this.orderedSegments.push(segment);
        this.segmentLookup[segId] = segment;
      }
      this.currentTime = 0.0;
      this.setupTiming();
      this.div.on('mouseover', function() {
        return d3.select(this).transition().style('opacity', 1.0).duration(250);
      });
      this.div.on('mouseout', function() {
        return d3.select(this).transition().style('opacity', 0.0).duration(250);
      });
    }

    Timeline.prototype.setupTiming = function() {
      var beat, duration, runningTime, segId, _i, _len, _ref,
        _this = this;
      runningTime = 0.0;
      _ref = this.scene.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        beat = _ref[_i];
        segId = beat.elementId;
        duration = beat.duration();
        this.segmentLookup[segId].duration = duration;
        this.segmentLookup[segId].start = runningTime;
        runningTime += duration;
      }
      this.totalDuration = runningTime;
      this.tScale = d3.scale.linear().domain([0.0, this.totalDuration]).range([0.0, 100.0]);
      this.markers = this.svg.selectAll('.timeline-segment-marker').data(this.orderedSegments).attr('cx', function(d) {
        console.log('marker at: ' + _this.tScale(d.start));
        return _this.tScale(d.start) + '%';
      });
      this.markers.enter().append('circle').attr('cy', '50%').attr('cx', function(d) {
        console.log('marker at: ' + _this.tScale(d.start));
        return _this.tScale(d.start) + '%';
      }).attr('r', 5).attr('class', 'timeline-segment-marker').attr('timelinetooltip', function(d) {
        return d.title;
      });
      this.markers.on('mouseover', function(d) {
        return d3.select(this).transition().attr('r', 7).duration(250);
      });
      this.markers.on('mouseout', function(d) {
        return d3.select(this).transition().attr('r', 5).duration(250);
      });
      this.markers.on('click', function(d) {
        _this.scene.stop();
        return _this.scene.runAtSegment(d.title);
      });
      return $('.timeline-segment-marker').tipsy({
        gravity: 'sw',
        title: function() {
          console.log(this);
          return d3.select(this).attr('timelinetooltip');
        }
      });
    };

    Timeline.prototype.update = function(segId, t) {
      var newWidth;
      if (!(this.tScale != null)) {
        return;
      }
      console.log(segId);
      this.currentTime = t;
      newWidth = this.tScale(this.segmentLookup[segId].start + this.currentTime);
      return this.progressbar.attr('width', newWidth + '%');
    };

    return Timeline;

  })();

}).call(this);
