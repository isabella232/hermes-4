/*
  ---

  HERMES.App

  The main HERMES app for the backend. Init on each page load

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---
*/

!(function($, ns, w){
  'use strict';

  // augment string prototype to get the view title 
  // if data-view is defined on an html element, and it's "view-example"
  // this method translates it to ViewExample
  String.prototype.toViewTitle = String.prototype.toViewTitle || function() {
    var n = this.split('-'),
        len = n.length,
        i = 0,
        l = '',
        r = '',
        accumulator = ''
    ;
    l = n[0].charAt(0).toUpperCase() + n[0].slice(1);
    accumulator = l;
    for(; i < len; i ++) {
      l = n[i].charAt(0).toUpperCase() + n[i].slice(1);
      r = n[i+1] ? n[i+1].charAt(0).toUpperCase() + n[i+1].slice(1) : '';
      accumulator += r;
    }
    return accumulator;
  };


  /**
    *
    * App class
    * ctor 
    *
    *
    **/

  var App = function() {
    this.version = '0.1';
    this.components = {};
    this.init();
  };


  /**
    *
    * destroyTutorial
    *
    * destroys a tutorial
    *
    * @param {tutorialID} Number, the tutorial ID
    * @param {path} String, where to redirect
    *
    * @return nothing
    *
    **/

  App.prototype.destroyTutorial = function(tutorialId, path) {
    if (this.components.TutorialCollection) {
      this.components.TutorialCollection.destroyTutorial(tutorialId);
    } else {
      w.location.href = path;
    }
  }


  /**
    *
    * _startBootstrap
    *
    * init all the bootstrap stuff
    *
    * @return nothing
    *
    **/

  App.prototype._startBootstrap = function() {
    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();
    $('.datetimepicker').datetimepicker({ language: 'en-US', pickTime: true });
    $('textarea').autosize();
    $('input, textarea').placeholder();
  }


  /**
    *
    * _startZeroClipboard
    *
    * for the copy&paste stuff on site show
    *
    * @return nothing
    *
    **/

  App.prototype._startZeroClipboard = function() {
    var errorZeroClipboard = false,
        zeroClient = new ZeroClipboard,
        copyElement = $('.copy-element')
    ;
    copyElement.parents('.embed-element').data('hermes.to', null)
    zeroClient.on('ready', function(evt) {
      zeroClient.on('aftercopy', function(evt) {
        var embedElem = $(evt.target).parents('.embed-element');
        embedElem.addClass('copied');
        clearTimeout(embedElem.data('hermes.to'));
        embedElem.data('hermes.to', setTimeout(function() {
          embedElem.removeClass('copied');
        }, 500));
      });
    });
    zeroClient.on('error', function() {
      copyElement.remove();
    });
    zeroClient.clip(copyElement);
  };


  /**
    *
    * _findAndInstantiateViews
    *
    * check if there're elements w/ data-view as attribute. If some are found, instantiate
    * the right view
    *
    * @return nothing
    *
    **/

  App.prototype._findAndInstantiateViews = function() {
    $('[data-view]:not([data-instantiated=true])').each(function(i, el){
      var viewName = $(el).data('view').toViewTitle();
      $(el).attr('data-instantiated', true);
      this.components[viewName] = new ns[viewName]($(el));
    }.bind(this));
  }


  /**
    *
    * init
    *
    * init the various methods
    *
    * @return nothing
    *
    **/

  App.prototype.init = function() {
    this._startBootstrap();
    this._findAndInstantiateViews();
    this._startZeroClipboard();
  };


  // export the instance
  ns.App = new App();

})(jQuery, HERMES, this);
