/*
  ---

  __hermes_embed.GeneralMessaging

  The GeneralMessaging class. 
  When a user loads a page on a website authored on hermes, there can be general messages. This class' instance handles them and 
  when they're over, it will publish a message so hermes will know it can ask the server to check for tutorials.

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---
*/

__hermes_embed.init_general_messaging = function($) {

  !(function(w, ns){

    var DOC = $(document),
        BODY = $(document.body),
        DEFAULTS = {
          snoozeTimeOut: 250, //ms
          retrieveMessagesUrl: '/messages.js?site_ref=' + ns.site_ref
        }
    ;


    /**
      *
      * GeneralMessaging class
      * ctor 
      * @param {options}
      *
      * @return nothing
      *
      **/

    var GeneralMessaging = function(options) {
      this.version = '0.1';
      this.options = $.extend({}, DEFAULTS, options);
      this.queue = [];
      this.init();
    };


    /**
      *
      * saveTipStateAndSnooze
      *
      * once a tip is displayed and user closes it, save the state on the server by doing a jsonp request against tip.url
      *
      * @param {tip} the tip/broadcast that has been displayed
      * @param {evt} DOM event
      *
      * @return nothing
      *
      **/

    GeneralMessaging.prototype.saveTipStateAndSnooze = function(tip, evt) {
      evt.preventDefault();
      evt.stopPropagation();
      evt.stopImmediatePropagation();

      $(w).trigger('hermes.dismiss-message');

      $.ajax(tip.url, {
        dataType: 'jsonp',
        complete: function(jqXHR, status) { /* Nothing, for now */ }
      });
    }


    /**
      *
      * enqueue
      *
      * set the general messages queue and start dequeuing it
      *
      * @param {messages} an array of tips/broadcasts
      *
      * @return nothing
      *
      **/

    GeneralMessaging.prototype.enqueue = function(messages) {
      this.queue = messages;
      this.dequeue();
    }


    /**
      *
      * dequeue
      *
      * remove the tip/broadcast from the queue and display it
      *
      * @return nothing
      *
      **/

    GeneralMessaging.prototype.dequeue = function() {
      var currentTip = null,
          tipElement = null;
      if (this.queue.length === 0) {
        ns.publish('generalMessagingOver', []);
        return;
      }
      currentTip = this.queue.shift();
      if (currentTip.type === 'tip') {
        tipElement = $(currentTip.selector);
        if (tipElement.length === 0 || !tipElement.is(':visible')) {
          this.dequeue();
          return;
        }
      }
      ns.display(currentTip);

      $(w).one('hermes.dismiss-message', function () {
        setTimeout(this.dequeue.bind(this), this.options.snoozeTimeOut);
      }.bind(this));
    }


    /**
      *
      * init
      *
      * ask the server for all the general messages and subscribe to the messages that can occur while 
      * user views messages
      *
      * @return nothing
      *
      **/

    GeneralMessaging.prototype.init = function() {
      $.ajax(ns.host + this.options.retrieveMessagesUrl, {
        dataType: 'jsonp',
        success: this.enqueue.bind(this)
      });
      ns.subscribe('tipHidden', function(tip, evt){
        this.saveTipStateAndSnooze(tip, evt);
      }.bind(this));
      ns.subscribe('broadcastHidden', function(broadcast, evt){
        this.saveTipStateAndSnooze(broadcast, evt);
      }.bind(this));
    }


    // export it
    ns.GeneralMessaging = GeneralMessaging;

  })(window, __hermes_embed);

};