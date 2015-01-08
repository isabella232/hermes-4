/*
  ---

  __hermes_embed.App

  The main hermes file. Here we manage all the embedded code and what 
  actions to perform for each particular state.

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---

  Embedded Hermes Flow:
    * page is being loaded
    * this javascript is loaded one way or the other
    
    1 - check the message from the opener (if any) or init the App on window load

    2 - jquery checker
    3 - type of action (by message received, or by standard init, or by cookie/QS check if in the middle of a tutorial)
            /      \                             /                       /
    3a - Authoring  \                         /                         /
      3b - General messaging               /                           /
        3c - Tutorials (can be multipage, + more than 1 per page)     /
                                                3d- Tutorial already started

    3a => Authoring
      4 - enable mouse move
      5 - on user click, check css Path
      6 - post message to window.opener containing the css path of the element that has been clicked

    3b => General messaging
      4 - automagically make a JSONP call to the server to obtain all the *general* messages of the website for that path
      5 - on JSONP callback, check sequentially the messages
      6 - check the type of the message
      6a - is it a tip?
         show the tip via popover plugin.
         On *got it* click, save state on the server via jSonp request
      6b - is it a broadcast?
         show the broadcast message
         On *close* click, save state on the server via jSonp request
      7- after last general messaging message, start checking if there're tutorials for that page.

    3c => Tutorials
      4 - if there're no (more) general messages, make a JSONP call to obtain the Tutorials
      5 - on JSONP callback, render the tutorials list
      6 - on Tutorial start (by selecting it from the list or by clicking on a dom element if selector tutorial)
        6a - check tip type and show tip via popover plugin or broadcast
        6b - go to the next tip (or prev) and if path changes, redirect user to that page
      7 - on tutorial ends, save state on the server (same as general messaging)
    
    3d => Tutorial already started
      4 - check tutorial id and current message index by query string (if absolute url) or cookie (if same domain)
      5 - start that tutorial from that message
      6 - continue the tutorial (this step can be recursive obv if more than 1 path changes)
      7 - on tutorial ends, save state on the server (same as general messaging) and start general messaging (3b)
*/

!(function(w, ns){
  'use strict';



  /**
    *
    * App class. 
    * 
    * instances
    *
    * @return {this} chainability
    *
    **/

  var App = function() {
    this.version = '0.1';
    this.mode = ''; // authoring / preview / general-messaging / tutorial
    new ns.JQueryChecker(function($){ this.init($) }.bind(this));
    return this;
  };



  /**
    * initPubSub
    * the pubsub pattern, very useful to send/receive messages throughout the application
    *
    * @param {$} function, the jQuery object noconflicted
    *
    * @return {this} chainability
    *
    **/

  App.prototype.initPubSub = function($) {

    ns.subscriptions = {};

    ns.publish = function(topic, args) {
      ns.subscriptions[topic] && $.each(ns.subscriptions[topic], function() {
        this.apply(ns, args || []);
      });
    };

    ns.subscribe = function(topic, callback) {
      if (!ns.subscriptions[topic]) {
        ns.subscriptions[topic] = [];
      }
      ns.subscriptions[topic].push(callback);
      return [topic, callback];
    };

    ns.unsubscribe = function(handle) {
      var t;
      t = handle[0];
      ns.subscriptions[t] && $.each(ns.subscriptions[t], function(idx) {});
      if (this === handle[1]) {
        ns.subscriptions[t].splice(idx, 1);
      }
    };

    return this;
  }



  /**
    * createTutorialCookies
    *
    * @param {tutorialId} Number, the id of the tutorial being saved on cookies
    * @param {tipIndex} Number, the index of the current tip
    * @param {direction} String, the direction of the tutorial prev|next
    *
    * @return {this} chainability
    *
    **/

  App.prototype.createTutorialCookies = function(tutorialId, tipIndex, direction) {
    ns.cookie.create('hermes-tutorial-started', 'true');
    ns.cookie.create('hermes-tutorialid', tutorialId);
    ns.cookie.create('hermes-tipindex', tipIndex);
    ns.cookie.create('hermes-tutorialdirection', direction);
    return this;
  }



  /**
    * deleteTutorialCookies
    * remove all the tutorial cookies
    *
    * @return {this} chainability
    *
    **/

  App.prototype.deleteTutorialCookies = function() {
    ns.cookie.erase('hermes-tutorial-started');
    ns.cookie.erase('hermes-tutorialid');
    ns.cookie.erase('hermes-tipindex');
    ns.cookie.erase('hermes-tutorialdirection');
    return this;
  }



  /**
    * initSubscriptions
    * Define all the general subscriptions. 
    * All the events that are fired throughout embedded application, should be handled here.
    *
    * @return {this} chainability
    *
    **/

  App.prototype.initSubscriptions = function($) {

    var availableTutorialsTO = null;

    // when a tutorial is deleted (RARE case, it can happen when page is changed during a tutorial, but in the meanwhile
    // that tutorial has been deleted from the hermes backend)
    // called from Tutorial.prototype.initStarted
    ns.subscribe('tutorialdeleted', function() {
      this.deleteTutorialCookies();
      this.mode = 'general-messaging';
      this.initMode();
      ns.publish('showAvailableTutorials');
    }.bind(this));

    // when the general messaging is finished (last message has been displayed)
    // start tutorials check (if there're any tutorials for that page)
    // called from GeneralMessaging.prototype.dequeue
    ns.subscribe('generalMessagingOver', function() {
      this.mode = 'tutorial';
      ns.instances.tutorialmanager = new ns.TutorialsManager;
    }.bind(this));

    // Whenever I start a tutorial I hide the tutorials list
    // called from Displayer.prototype.displayTutorialStarter
    ns.subscribe('hideAvailableTutorials', function() {
      if (ns.DOM.availableTutorialsDisplayer) {
        ns.DOM.availableTutorialsDisplayer.removeClass('open displayed');
        clearTimeout(availableTutorialsTO);
        availableTutorialsTO = setTimeout(function(){
          ns.DOM.availableTutorialsDisplayer.hide();
        }, 300);
      }
    });

    // Whenever a tutorial ends or is deleted, show the available tutorials list
    // called from App.prototype.initSubscriptions
    ns.subscribe('showAvailableTutorials', function() {
      if (ns.DOM.availableTutorialsDisplayer) {
        ns.DOM.availableTutorialsDisplayer.show();
        clearTimeout(availableTutorialsTO);
        availableTutorialsTO = setTimeout(function(){
          ns.DOM.availableTutorialsDisplayer.addClass('displayed');
        }, 10);
      }
    });

    // Whenever user clicks on restart tutorial
    // called from Tutorial.prototype.restart
    ns.subscribe('tutorialrestarted', function(tutorial) {
      // reset active tutorial
      ns.activeTutorial = null;
      ns.DOM.progressBar && ns.DOM.progressBar.hide();
      if (ns.DOM.overlay) {
        $(document.body).removeClass('hermes--is-overflow-hidden');
        ns.DOM.overlay.hide();
      }
      tutorial.start();
    }.bind(this));

    // Whenever a tutorial starts, set the global activeTutorial
    // variable and hide the tutorials list by publishing the message
    // called from Tutorial.prototype.start
    ns.subscribe('tutorialstarted', function(tutorial) {
      // flag the app w/ active tutorial (no other tutorials can be started while one is executing!)
      ns.activeTutorial = tutorial;
      ns.publish('hideAvailableTutorials');
    });

    // Whenever a tutorial ends, send jsonp request to the server to 
    // set the proper state for that tutorial, and 'reset' the states/variables
    // called from Tutorial.prototype.end
    ns.subscribe('tutorialended', function(url, skip) {
      if (!skip) {
        $.ajax(url, {
          dataType: 'jsonp',
          complete: function(jqXHR, status) { /* Nothing, for now */ }
        });
      }
      // reset active tutorial
      ns.activeTutorial = null;
      ns.publish('showAvailableTutorials');
      ns.DOM.progressBar && ns.DOM.progressBar.hide();
      if (ns.DOM.overlay) {
        $(document.body).removeClass('hermes--is-overflow-hidden');
        ns.DOM.overlay.hide();
      }
      if (this.mode === 'started-tutorial') {
        this.mode = 'general-messaging';
        this.initMode();
      };
    }.bind(this));

    // When a tutorial needs to be loaded, check if it's already 
    // instantiate, otherwise define a new tutorial
    // called from TutorialsManager.prototype.initSelectorTutorials
    //             Displayer.prototype.displayAvailableTutorials
    ns.subscribe('loadTutorial', function(tutorial) {
      var isLoadedTutorial = ns.tutorials['tutorial' + tutorial.id];
      if (!!isLoadedTutorial) {
        if (!tutorial.selector){
          isLoadedTutorial.start();
        }
      } else {
        ns.tutorials['tutorial' + tutorial.id] = new ns.Tutorial(tutorial);
      }
    });

    return this;
  }



  /**
    * initMode
    * check the app mode and init the class that matches the mode
    * if we're in the middle of a tutorial, retrieve the tutorial info
    * and start it!
    *
    * @return {this} chainability
    *
    **/

  App.prototype.initMode = function() {
    switch(this.mode){
      case 'started-tutorial':
        ns.tutorials = ns.tutorials || {}; // not yet defined as we're in the middle of a tutorial
                                           // so no tutorial manager instantiated (check for future in case
                                           // we will enable tutorials manager)
        var tutorialId = ns.utils.getParameterByName('hermes_tutorial_id') || ns.cookie.read('hermes-tutorialid'),
            tipIndex = ns.utils.getParameterByName('hermes_tip_index') || ns.cookie.read('hermes-tipindex');
        ns.currentTutorialDirection = ns.utils.getParameterByName('hermes_tutorial_direction') || ns.cookie.read('hermes-tutorialdirection');
        ns.tutorials['tutorial' + tutorialId] = new ns.Tutorial({}, {
          tutorialId : tutorialId,
          tipIndex   : tipIndex
        });
        this.deleteTutorialCookies();
        break;
      case 'authoring-tutorial':
      case 'authoring':
        ns.instances.authoring = new ns.Authoring;
        break;
      case 'preview':
        ns.instances.preview = new ns.Preview;
        break
      case 'general-messaging':
        ns.instances.generalmessaging = new ns.GeneralMessaging;
        break;
    }
    return this;
  }



  /**
    * initClasses
    * init all the classes. This is needed to keep the $ isolated.
    *
    * @param {$} function, the jQuery object noconflicted
    *
    * @return {this} chainability
    *
    **/


  App.prototype.initClasses = function($){
    ns.init_displayer($);
    ns.init_tutorial($);
    ns.init_tutorials_manager($);
    ns.init_popover($);
    ns.init_authoring($);
    ns.init_preview($);
    ns.init_general_messaging($);
    // setup the displayer (that will be always needed)
    ns.instances.displayer = new ns.Displayer;
    ns.display = ns.instances.displayer.display.bind(ns.instances.displayer);
    return this;
  }


  /**
    * init
    * The 1st method that is called automatically after the new. 
    * Check if there're started tutorials, then 
    * set the mode, and call initSubscriptions + initMode
    *
    * @param {$} function, the jQuery object noconflict
    *
    * @return {this} chainability
    *
    **/

  App.prototype.init = function($){
    var path = '',
        startedTutorial = ns.cookie.read('hermes-tutorial-started') !== null || ns.utils.getParameterByName('hermes_tutorial_id') !== ''
    ;
    this.initPubSub($);
    this.initClasses($);
    if (ns.mode === '__init__') {
      if (startedTutorial) {
        this.mode = 'started-tutorial';
      } else{
        this.mode = 'general-messaging';
      }
    } else {
      this.mode = ns.mode;
    }
    ns.instances.app = this;
    this.initSubscriptions($);
    this.initMode();
  };

  // create the instances object
  ns.instances = {};


  // callback when the message from the opener has been received
  var messageReceived = function(evt) {
    if (evt.data === 'preview' ||
        evt.data === 'authoring' ||
        evt.data === 'authoring-tutorial'){
      w.removeEventListener('message', messageReceived);
      ns.mode = evt.data;
      // start the app
      new App;
    }
  }

  // listener for the message that eventually will send 
  // us the opener
  w.addEventListener('message', messageReceived);

  // start it when page is loaded!
  w.onload = function() {
    if (w.opener) {
      // let the opener tell us the mode
      w.opener.postMessage('__get__mode__', ns.host);
    } else {
      // otherwise, init the app!
      ns.mode = '__init__';
      new App;
    }
  };

})(this, __hermes_embed);