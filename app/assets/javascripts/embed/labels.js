/*
  ---

  __hermes_embed.labels

  The labels

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---
*/



!(function(w, ns) {
  'use strict';

  /**
  *
  * Labels object. It stores the labels used around the embed app
  *
  **/

  var labels = {
    alertBindTutorial           : 'you can\'t bind a tutorial start on <a> or <button type="submit"> elements! :(',
    elementNoMorePresent        : 'The element attached to the tip is no more present in this page! (hint: Is it maybe attached to a dynamically generated element?)',
    elementPositionFixedWarning : 'The item you\'re going to bind has position:fixed(or it has a parent with position:fixed). The tip will be bound to that element to preserve page scrolling. Check whether that fixed element doesn\'t have overflow:hidden. Proceed?',
    noMoreTips                  : 'No more tips to display for this tutorial!',
    alreadyViewed               : 'Already viewed'
  }


  // export it
  ns.labels = labels;

})(this, __hermes_embed);