/*
  ---

  HERMES.EntityEdit

  Tip/Tutorial edit form management

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
    * EntityEdit class
    * ctor 
    * @param {element} the form element
    *
    * @return {this} chainability
    *
    **/

  var EntityEdit = function(element) {
    this.version = '0.1';
    this.element = element || b;
    this.init();
    return this;
  };


  /**
    *
    * submitForm
    *
    * on submit, set the textarea value as the serialized value of the contenteditable element
    *
    * @param {evt} the DOM event
    *
    * @return nothing
    *
    **/

  EntityEdit.prototype.submitForm = function(evt) {
    this.element.find('.textarea-target').val(this.contentEditor.serialize()['element-0'].value);
  }


  /**
    *
    * toggleAbsoluteUrl
    *
    * toggle the absolute url option for the tooltip
    *
    * @param {evt} the DOM event
    *
    * @return nothing
    *
    **/

  EntityEdit.prototype.toggleAbsoluteUrl = function(evt) {
    if ($(evt.target).is(':checked')) {
      this.element.find('.input-addon-abs-path').removeClass('hide');
      this.element.find('.input-addon-current-path').addClass('hide');
    } else {
      this.element.find('.input-addon-abs-path').addClass('hide').find('select').val('');
      this.element.find('.input-addon-current-path').removeClass('hide');
    }
  }


  /**
    *
    * selectPath
    *
    * focus to the path on click on the addon on the left
    *
    * @param {evt} the DOM event
    *
    * @return nothing
    *
    **/

  EntityEdit.prototype.selectPath = function(evt) {
    var path = $(evt.target).parents('.input-group').find('input:text'),
        pathV = path.val()
    ;
    path.focus().get(0).setSelectionRange(pathV.length,pathV.length);
  }


  /**
    *
    * init
    *
    * set external connector (if defined), the editor and the events
    *
    * @return {this} (current instance, chaining purpose)
    *
    **/

  EntityEdit.prototype.init = function() {
    this.element.find('input:text').first().focus();
    !!this.element.data('externalconnector') && this.element.externalconnector();
    this.contentEditor = new MediumEditor(this.element.find('.textarea-editable'), {
      buttons: ['bold', 'italic', 'underline', 'anchor', 'orderedlist', 'unorderedlist'],
      targetBlank: true
    });
    this.element.on('submit', 'form', this.submitForm.bind(this));
    this.element.on('click', '.input-group-addon-text:not(.input-addon-abs-path)', this.selectPath.bind(this));
    this.element.on('change', '#absolute_url', this.toggleAbsoluteUrl.bind(this));
    return this;
  };

  // export it via provided namespace
  ns.EntityEdit = EntityEdit;

})(jQuery, HERMES, this);