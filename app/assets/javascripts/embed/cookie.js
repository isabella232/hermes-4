/*
  ---

  __hermes_embed.cookie

  Just a simple static utility that can be used to create/read/erase cookies.

  (c) IFAD 2015
  @author: Stefano Ceschi Berrini <stefano.ceschib@gmail.com>
  @license: see LICENSE.md

  ---
*/


!(function(w, ns){
  'use strict';

  ns.cookie = {

    /**
      * create
      *
      * this function creates a cookie by setting document.cookie
      *
      * @param name String, the name of the cookie
      * @param value String, the value of the cookie
      * @param days Number(optional), the duration of the cookie
      * 
      * @return nothing
      *
      **/

    create: function(name, value, days) {
      if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
      }
      else var expires = "";
      document.cookie = name+"="+value+expires+"; path=/";
    },


    /**
      * create
      *
      * this function read a cookie
      *
      * @param name String, the name of the cookie
      * 
      * @return String the cookie value, or null
      *
      **/

    read: function(name) {
      var nameEQ = name + "=";
      var ca = document.cookie.split(';');
      for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
      }
      return null;
    },


    /**
      * erase
      *
      * this function removes a cookie
      *
      * @param name String, the name of the cookie
      * 
      * @return nothing
      *
      **/
    erase: function(name) {
      this.create(name,"",-1);
    }

  };


})(this, __hermes_embed);