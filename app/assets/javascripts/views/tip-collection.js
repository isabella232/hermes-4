/*
  ---

  HERMES.TipCollection

  The view for tip collection (tip index, tutorial show)

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
    * TipCollection class
    * ctor 
    *
    * @param {element} the element that wraps the tip collection
    *
    * @return {this} chainability
    *
    **/

  var TipCollection = function(element) {
    this.version = '0.1';
    this.element = element || b;
    this.init();
    return this;
  };


  /**
    *
    * destroyTip
    * 
    * this is called when a tip is destroyed and DOM element needs to be removed
    *
    * @param {id} Number, the id of the tip
    *
    **/

  TipCollection.prototype.destroyTip = function(id) {
    this.element.find('[data-tip-id=' + id + ']').remove();
    if (this.element.find('.entity').length === 0) {
      this.element.find('.hero-unit').removeClass('hide');
      this.element.find('.tip-collection-top').addClass('hide');
      this.element.find('.hero-unit').addClass('animated bounceIn');
    }
  }


  /**
    *
    * _receiveMessage
    * 
    * this is the handler for the postMessage's 'message' listener
    *
    * @param {evt} event, the event of the postMessage 
    *
    **/

  TipCollection.prototype._receiveMessage = function(evt) {
    if (evt.data === '__get__mode__') {
      this.openedWindow.postMessage('preview', this.openedWindowHref);
    } else if (evt.data === '__get__tip__path') {
      this.openedWindow.postMessage(this.currentTarget.data('messagepath'), this.openedWindowHref);
    }
    return this;
  }


  /**
    *
    * openExternalLink
    * 
    * open the url for preview
    *
    * @param {evt} event, the DOM event
    *
    **/

  TipCollection.prototype.openExternalLink = function(evt) {
    evt.preventDefault();
    var $target = $(evt.target);
    $target = $target.is('a') ? $target : $target.parent('a');
    this.currentTarget = $target;
    this.openedWindow = w.open($target.attr('href'));
    this.openedWindowHref = $target.attr('href');
  }


  /**
    *
    * init
    * 
    * start the sortable on tips and set event handling
    *
    * @param {evt} event, the DOM event
    *
    **/

  TipCollection.prototype.init = function() {
    this.element.find('.tips-container').sortable({
      revert: true,
      start: function(event, ui) {
        ui.item.removeClass('animated fadeIn');
      },
      update: function(event, ui) {
        var pos = $('.tips-container').find('.entity').index(ui.item);
        $.ajax("/tips/" + ui.item.attr('data-tip-id') + '/position', {
          data: { pos: pos },
          type: 'put',
          success: function() {
          }
        });
      }
    });
    this.element.find('.tips-container').disableSelection();
    this.element.on('click', 'a.ext', this.openExternalLink.bind(this));
    w.addEventListener('message', this._receiveMessage.bind(this), false);
    return this;
  };

  // export it via provided namespace

  ns.TipCollection = TipCollection;

})(jQuery, HERMES, this);