(function() {
  var LessonElement, currentObj, currentStack, elementCounter, popCurrent, pushCurrent, root, uniqueElementId,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : exports;

  root.registry = [];

  root.scenes = {};

  root.stages = [];

  currentStack = [];

  currentObj = void 0;

  pushCurrent = function(obj) {
    currentStack.push(currentObj);
    return currentObj = obj;
  };

  popCurrent = function() {
    return currentObj = currentStack.pop();
  };

  elementCounter = -1;

  uniqueElementId = function() {
    elementCounter += 1;
    return 'element_assigned_id_' + elementCounter;
  };

  mcb80x.LessonElement = (function() {

    function LessonElement(elementId) {
      this.elementId = elementId;
      if (!(this.elementId != null)) {
        this.elementId = uniqueElementId();
      }
      registry[this.elementId] = this;
      this.children = [];
      this.childIndexLookup = {};
      this.childLookup = {};
      this.parent = void 0;
    }

    LessonElement.prototype.addChild = function(child) {
      child.parent = this;
      this.children.push(child);
      this.childIndexLookup[child.elementId] = this.children.length - 1;
      return this.childLookup[child.elementId] = child;
    };

    LessonElement.prototype.init = function() {
      var child, _i, _len, _ref, _results;
      if (this.children != null) {
        _ref = this.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          _results.push(child.init());
        }
        return _results;
      }
    };

    LessonElement.prototype.resumeAfterChild = function(child) {
      var childId, childIndex;
      childId = child.elementId;
      console.log('resumeAfter: ' + childId);
      if (!(this.children != null) || this.children.length === 0) {
        this["yield"]();
      }
      childIndex = this.childIndexLookup[childId];
      return this.resumeAfterIndex(childIndex);
    };

    LessonElement.prototype.resumeAfterIndex = function(childIndex) {
      var nextIndex;
      nextIndex = childIndex + 1;
      if (this.children[nextIndex] != null) {
        return this.children[nextIndex].run();
      } else {
        return this["yield"]();
      }
    };

    LessonElement.prototype.runChildrenStartingAtIndex = function(index, cb) {
      console.log('runStartingAtIndex index: ' + index);
      if (index > this.children.length - 1) {
        this["yield"]();
        return;
      }
      return this.children[index].run();
    };

    LessonElement.prototype["yield"] = function() {
      if (this.parent != null) {
        return this.parent.resumeAfterChild(this);
      } else {
        console.log('no parent:');
        return console.log(this);
      }
    };

    LessonElement.prototype.run = function() {
      if (!(this.children != null)) {
        return this["yield"]();
      } else {
        return this.runChildrenStartingAtIndex(0);
      }
    };

    LessonElement.prototype.runAtSegment = function(path) {
      var head, splitPath;
      if (path === '') {
        return this.run();
      }
      splitPath = path.split(':');
      head = splitPath.shift();
      return this.childLookup[head].runAtSegment(splitPath.join(':'));
    };

    LessonElement.prototype.stop = function() {
      var child;
      if ((function() {
        var _i, _len, _ref, _results;
        _ref = this.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          _results.push(child.stop != null);
        }
        return _results;
      }).call(this)) {
        return child.stop();
      }
    };

    return LessonElement;

  })();

  LessonElement = mcb80x.LessonElement;

  mcb80x.Scene = (function(_super) {

    __extends(Scene, _super);

    function Scene(title, elId) {
      var eleId;
      this.title = title;
      if (!(elId != null)) {
        eleId = this.title;
      }
      Scene.__super__.constructor.call(this, elId);
      scenes[elId] = this;
      this.currentSegment = ko.observable(void 0);
      this.currentTime = ko.observable(void 0);
    }

    Scene.prototype.run = function() {
      this.init();
      console.log('scene[' + this.elementId + ']');
      return Scene.__super__.run.call(this);
    };

    return Scene;

  })(LessonElement);

  mcb80x.Interactive = (function(_super) {

    __extends(Interactive, _super);

    function Interactive(elId) {
      this.duration = ko.observable(1.0);
      Interactive.__super__.constructor.call(this, elId);
    }

    Interactive.prototype.stage = function(s) {
      if (s != null) {
        return this.stageObj = s;
      } else {
        return this.stageObj;
      }
    };

    Interactive.prototype["yield"] = function() {
      if ((this.stageObj != null) && (this.stageObj.hide != null)) {
        this.stageObj.hide();
      }
      return Interactive.__super__["yield"].call(this);
    };

    Interactive.prototype.run = function() {
      this.parent.currentSegment(this.elementId);
      if (this.stageObj != null) {
        this.stageObj.show();
      }
      return Interactive.__super__.run.call(this);
    };

    Interactive.prototype.scene = function() {
      return this.parent;
    };

    return Interactive;

  })(LessonElement);

  mcb80x.Video = (function(_super) {

    __extends(Video, _super);

    function Video(elId) {
      this.duration = ko.observable(1.0);
      this.mediaUrls = {};
      Video.__super__.constructor.call(this, elId);
    }

    Video.prototype.media = function(fileType, url) {
      if (url != null) {
        return this.mediaUrls[fileType] = url;
      } else {
        return this.mediaUrls[fileType];
      }
    };

    Video.prototype.mediaTypes = function() {
      var k;
      return [
        (function() {
          var _results;
          _results = [];
          for (k in this.mediaUrls) {
            _results.push(k);
          }
          return _results;
        }).call(this)
      ];
    };

    Video.prototype.subtitles = function(f) {};

    Video.prototype.init = function() {
      var _this = this;
      if (!(this.pop != null)) {
        this.pop = Popcorn.smart('#vid', this.media('mp4'));
      }
      this.pop.on('durationchange', function() {
        console.log('duration changed!:' + _this.pop.duration());
        return _this.duration(_this.pop.duration());
      });
      console.log('Loading: ' + this.media('mp4'));
      this.pop.load(this.media('mp4'));
      return Video.__super__.init.call(this);
    };

    Video.prototype.show = function() {
      return d3.select('#video').transition().style('opacity', 1.0).duration(1000);
    };

    Video.prototype.hide = function() {
      return d3.select('#video').transition().style('opacity', 0.0).duration(1000);
    };

    Video.prototype.run = function(cb) {
      var scene, updateTimeCb,
        _this = this;
      this.parent.currentSegment(this.elementId);
      this.show();
      scene = this.parent;
      console.log(scene);
      updateTimeCb = function() {
        var t;
        t = this.currentTime();
        return scene.currentTime(t);
      };
      this.pop.on('timeupdate', updateTimeCb);
      cb = function() {
        console.log('popcorn triggered cb');
        console.log(cb);
        _this.pop.off('ended', cb);
        _this.pop.off('updatetime', updateTimeCb);
        _this.hide();
        return _this["yield"]();
      };
      this.pop.on('ended', cb);
      return this.pop.play(0);
    };

    Video.prototype.stop = function() {
      this.pop.pause();
      return this.hide();
    };

    return Video;

  })(LessonElement);

  mcb80x.Line = (function(_super) {

    __extends(Line, _super);

    function Line(audio, text, state) {
      this.audio = audio;
      this.text = text;
      this.state = state;
      Line.__super__.constructor.call(this);
    }

    Line.prototype.init = function() {
      this.div = $('#prompt_overlay');
      this.div.hide();
      return Line.__super__.init.call(this);
    };

    Line.prototype.run = function() {
      var cb, k, v, _ref, _results,
        _this = this;
      cb = function() {
        return _this["yield"]();
      };
      this.div.text(this.text);
      this.div.dialog({
        dialogClass: 'noTitleStuff',
        resizable: true,
        title: null,
        height: 300,
        modal: true,
        buttons: {
          'continue': function() {
            $(this).dialog('close');
            return cb();
          }
        }
      });
      _ref = this.state;
      _results = [];
      for (k in _ref) {
        v = _ref[k];
        _results.push(this.parent.stage()[k] = v);
      }
      return _results;
    };

    return Line;

  })(LessonElement);

  mcb80x.PlayAction = (function(_super) {

    __extends(PlayAction, _super);

    function PlayAction(stageId) {
      this.stageId = stageId;
      PlayAction.__super__.constructor.call(this);
    }

    PlayAction.prototype.run = function() {
      console.log('running play action');
      this.parent.stage().play();
      return this["yield"]();
    };

    return PlayAction;

  })(LessonElement);

  mcb80x.StopAndResetAction = (function(_super) {

    __extends(StopAndResetAction, _super);

    function StopAndResetAction(stageId) {
      this.stageId = stageId;
      StopAndResetAction.__super__.constructor.call(this);
    }

    StopAndResetAction.prototype.run = function() {
      this.parent.stage().stop();
      return this["yield"]();
    };

    return StopAndResetAction;

  })(LessonElement);

  mcb80x.WaitAction = (function(_super) {

    __extends(WaitAction, _super);

    function WaitAction(delay) {
      this.delay = delay;
      WaitAction.__super__.constructor.call(this);
    }

    WaitAction.prototype.run = function() {
      var cb,
        _this = this;
      console.log('waiting ' + this.delay + ' ms...');
      cb = function() {
        return _this["yield"]();
      };
      return setTimeout(cb, this.delay);
    };

    return WaitAction;

  })(LessonElement);

  mcb80x.FSM = (function(_super) {

    __extends(FSM, _super);

    function FSM(states) {
      var actionObj, k, v, _ref;
      this.states = states;
      FSM.__super__.constructor.call(this);
      this.currentState = 'initial';
      this.delay = 500;
      this.startTime = void 0;
      this.stopping = false;
      _ref = this.states;
      for (k in _ref) {
        v = _ref[k];
        actionObj = new LessonElement();
        pushCurrent(actionObj);
        if (v.action != null) {
          v.action();
        }
        popCurrent();
        this.states[k].action = actionObj;
        this.addChild(actionObj);
      }
    }

    FSM.prototype.init = function() {
      this.stage = this.parent.stage();
      console.log('got stage = ' + this.stage);
      return FSM.__super__.init.call(this);
    };

    FSM.prototype.getElapsedTime = function() {
      var now;
      now = new Date().getTime();
      return now - this.startTime;
    };

    FSM.prototype.transitionState = function(state) {
      var stateObj, t, transitionTo,
        _this = this;
      if (this.stopping) {
        return;
      }
      stateObj = this.states[state];
      stateObj.elapsedTime = this.getElapsedTime();
      stateObj.stage = this.stage;
      transitionTo = stateObj.transition();
      if (transitionTo != null) {
        if (transitionTo === 'continue') {
          console.log('yielding...');
          return this["yield"]();
        } else {
          return this.runState(transitionTo);
        }
      } else {
        t = function() {
          return _this.transitionState(state);
        };
        return setTimeout(t, this.delay);
      }
    };

    FSM.prototype.runState = function(state, cb) {
      var _this = this;
      console.log('ACTION: state: ' + state);
      this.startTime = new Date().getTime();
      if (this.states[state].action != null) {
        this.states[state].action["yield"] = function() {
          return _this.transitionState(state);
        };
        return this.states[state].action.run();
      } else {
        return this.transitionState(state);
      }
    };

    FSM.prototype.run = function() {
      console.log('running fsm');
      this.stopping = false;
      return this.runState('initial');
    };

    FSM.prototype.stop = function() {
      this.stopping = true;
      return FSM.__super__.stop.call(this);
    };

    return FSM;

  })(LessonElement);

  root.scene = function(sceneId, title) {
    var sceneObj;
    sceneObj = new mcb80x.Scene(sceneId, title);
    return function(f) {
      currentObj = sceneObj;
      return f();
    };
  };

  root.interactive = function(beatId) {
    var beatObj;
    beatObj = new mcb80x.Interactive(beatId);
    currentObj.addChild(beatObj);
    return function(f) {
      pushCurrent(beatObj);
      f();
      return popCurrent();
    };
  };

  root.stage = function(name) {
    var s;
    s = stages[name];
    return currentObj.stage(s);
  };

  root.line = function(text, audio, state) {
    var lineObj;
    lineObj = new mcb80x.Line(text, audio, state);
    return currentObj.addChild(lineObj);
  };

  root.lines = line;

  root.video = function(name) {
    var videoObj;
    videoObj = new mcb80x.Video(name);
    currentObj.addChild(videoObj);
    return function(f) {
      pushCurrent(videoObj);
      f();
      return popCurrent();
    };
  };

  root.mp4 = function(f) {
    return currentObj.media('mp4', f);
  };

  root.webm = function(f) {
    return currentObj.media('webm', f);
  };

  root.subtitles = function(f) {
    return currentObj.subtitles(f);
  };

  root.duration = function(t) {
    if (currentObj.duration != null) {
      return currentObj.duration(t);
    }
  };

  root.play = function(name) {
    var runObj;
    runObj = new mcb80x.PlayAction(name);
    return currentObj.addChild(runObj);
  };

  root.wait = function(delay) {
    var waitObj;
    waitObj = new mcb80x.WaitAction(delay);
    return currentObj.addChild(waitObj);
  };

  root.stop_and_reset = function(name) {
    var stopResetObj;
    stopResetObj = new mcb80x.StopAndResetAction(name);
    return currentObj.addChild(stopResetObj);
  };

  root.goal = function(f) {
    var goalObj;
    goalObj = new mcb80x.FSM(f());
    return currentObj.addChild(goalObj);
  };

  root.fsm = goal;

}).call(this);
