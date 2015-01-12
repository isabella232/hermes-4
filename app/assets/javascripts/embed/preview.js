/*
  ---

  __hermes_embed.Preview

  The Preview class. 
  When the users requires a preview for a particular tip/broadcast (preview mode), this class 
  is instatiated and it just displays the tip/broadcast.

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---
*/

__hermes_embed.init_preview = function($) {

  !(function(w, ns){

    var DOC = $(document),
        BODY = $(document.body),
        DEFAULTS = {}
    ;


    /**
      *
      * Preview class
      * ctor 
      * @param {options}
      *
      * @return {this} chainability
      *
      **/

    var Preview = function(options) {
      this.version = '0.1';
      this.options = $.extend({}, DEFAULTS, options);
      this.init();
    };



    /**
      * init
      * display the preview mode label and, once the message is received,
      * display it (via the displayer)
      *
      * @return {this} chainability
      *
      **/

    Preview.prototype.init = function() {
      ns.display({type: 'preview', text: ns.labels.hermesPreviewMode});
      w.addEventListener('message', function(evt) { // once the opener replies with the tip path, retrieve the tip from the server
        $.ajax(ns.host + evt.data, {
          dataType: 'jsonp',
          success: function(message) {
            if(message.type === 'tip') {
              var elem = $(message.selector);
              if(elem.length === 0 || !elem.is(':visible')) { // check whether the element is present and
                                                              // if it's not present, tell to the user!
                alert(ns.labels.elementNoMorePresent);
                w.close();
                return;
              }
            }
            ns.display(message);
          }
        });
      });
      w.opener.postMessage('__get__tip__path', ns.host); // ask the opener the tip path
      ns.subscribe('tipHidden', function() {
        w.close();
      });
      ns.subscribe('broadcastHidden', function() {
        w.close();
      });
      return this;
    }


    // export it
    ns.Preview = Preview;

  })(window, __hermes_embed);

};