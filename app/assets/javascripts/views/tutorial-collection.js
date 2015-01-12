/*
  ---

  HERMES.TutorialCollection

  The view for tutorial collection (tutorial index)

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---
*/

!(function($, ns, w){
  'use strict';

  var b = $(document.body);


  /**
    *
    * TutorialCollection class
    * ctor 
    *
    * @param {element} the element that wraps the tutorial collection
    *
    * @return {this} chainability
    *
    **/

  var TutorialCollection = function(element) {
    this.version = '0.1';
    this.element = element || b;
    this.init();
    return this;
  };


  /**
    *
    * destroyTutorial
    * 
    * this is called when a tutorial is destroyed and DOM element needs to be removed
    *
    * @param {id} Number, the id of the tutorial
    *
    **/

  TutorialCollection.prototype.destroyTutorial = function(id) {
    this.element.find('[data-tutorial-id=' + id + ']').remove();
    if (this.element.find('.entity').length === 0) {
      this.element.find('.hero-unit').removeClass('hide');
      this.element.find('.tutorial-collection-top').addClass('hide');
      this.element.find('.hero-unit').addClass('animated bounceIn');
    }
  }

  TutorialCollection.prototype.init = function() {
    // nothing for now
  };

  // export it via provided namespace

  ns.TutorialCollection = TutorialCollection;

})(jQuery, HERMES, this);