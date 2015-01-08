__hermes_embed.init_tutorial = function($) {

  !(function(w, ns){

    if (ns.Tutorial) {
      return;
    }

    var DOC = $(document),
        BODY = $(document.body),
        DEFAULTS = {
          retrieveTutorialUrl: '/messages/tutorials/{{tutorial_id}}.js?site_ref=' + ns.site_ref,
          tipTargetAbsoluteQS: 'hermes_tutorial_id={{id}}&hermes_tip_index={{index}}&hermes_site_ref={{ref}}&hermes_tutorial_direction={{direction}}'
        }
    ;

    var Tutorial = function(options, startedOptions) {
      this.version = '0.1';
      if (startedOptions == null){
        this.options = $.extend({}, DEFAULTS, options);
        this.init();
      } else {
        this.options = $.extend({}, DEFAULTS);
        this.initStarted(startedOptions);
      }
      return this;
    };

    Tutorial.prototype.getCurrentIndex = function() {
      return this.currentTipIndex;
    }

    Tutorial.prototype.getTotalTips = function() {
      return this.tips.length;
    }

    Tutorial.prototype.isStarted = function() {
      return this.started;
    }

    Tutorial.prototype.isEnd = function() {
      return this.currentTipIndex === (this.tips.length - 1);
    }

    Tutorial.prototype.isBeginning = function() {
      return this.currentTipIndex === 0;
    }

    Tutorial.prototype.canDisplayTip = function(tip) {
      var 
          // current path (calculate it in this way, coz a site can be defined as http://example.com/path)
          pathCurrent = (location.host + location.pathname).replace(ns.site_ref, '') || '/',
          // the regexp defined for the tutorial
          pathRegexpTutorial = new RegExp(this.options.path_re),
          // the static path of the tutorial => to match tips
          pathStaticTutorial = this.options.path,
          // the host of the tips, because they can be absolute
          tipHostRef = tip.ext_site || this.options.site_ref,
          // check whether the tip is from the same current site 
          tipIsFromSameSite = tipHostRef.indexOf(location.host) > -1,
          // check whether the tip has same path as the current path (calculated as above)
          tipHasCurrentPath = tip.path === pathCurrent,
          // check whether tip has same static path of the tutorial and tutorial regexp path matches the current path
          tipHasCurrentTutorialPath = tip.path === pathStaticTutorial && pathRegexpTutorial.test(pathCurrent)

      ;
      // tip to be displayed must be on the same site (obv), must have the same path or 
      // must have the same tutorial path (that matches the current page's path)
      return tipIsFromSameSite && (tipHasCurrentPath || tipHasCurrentTutorialPath);
    }

    Tutorial.prototype.checkPathAndDisplay = function(tip, direction) {
      // if tip has been removed during I'm touring it (& I change path)... 
      // should be extremely RARE, but who knows...
      if (!tip) {
        alert(ns.labels.noMoreTips);
        this.end();
        return;
      }
      var tipHostRef = tip.ext_site || this.options.site_ref,
          tipIsFromSameSite = tipHostRef.indexOf(location.host) > -1
      ;
      // Check if tip needs to be displayed.
      if(this.canDisplayTip(tip)){
        // display the tip
        if (tip.type === 'tip') { // check tip selector
          var elem = $(tip.selector),
              direction = ns.currentTutorialDirection || direction;
          ns.currentTutorialDirection = null;
          if (elem.length === 0 || !elem.is(':visible')) { // if there's no match w/ selector on the page (RARE CASE)
            if(this.isEnd()) { // if I'm at the end, just warn the user
              alert(ns.labels.noMoreTips)
              this.end();
            } else { // otherwise, check direction and call the next|prev method
              direction === 'next' ? this.next() : this.prev();
            }
            return; // stop here
          }
        }
        // call the display method on the tip
        ns.display(tip);
        // show progress bar if defined
        this.options.progress_bar && ns.display({type: 'progressBar', tutorial: this});
      } else { // otherwise, change page!
        // delete cookies
        ns.instances.app.deleteTutorialCookies();
        // remove beforeunload event
        $(w).off('beforeunload');
        // remove overlay
        ns.DOM.overlay && ns.DOM.overlay.hide();
        if (tipIsFromSameSite) { // if same domain, create cookies and redirect!
          ns.instances.app.createTutorialCookies(this.id, this.currentTipIndex, direction || 'next');
          window.location.href = tip.path;
        } else { // otherwise, another domain! So append querystring to the url
          var ext_ref = (tip.ext_site || this.options.site_ref) + tip.path,
              absQS = this.options.tipTargetAbsoluteQS.replace('{{id}}', this.id)
                                         .replace('{{index}}', this.currentTipIndex)
                                         .replace('{{ref}}', this.options.site_ref)
                                         .replace('{{direction}}', direction || 'next');
          ext_ref = ext_ref + ((ext_ref.indexOf('?') > -1) ? '&' : '?');
          ext_ref = /^https?:\/\//.test(ext_ref) ? ext_ref : ('//' + ext_ref);
          window.location.href = ext_ref + absQS;
        }
      }
    }

    Tutorial.prototype.next = function() {
      this.checkPathAndDisplay(this.tips[++this.currentTipIndex], 'next')
      return this;
    }

    Tutorial.prototype.prev = function() {
      this.checkPathAndDisplay(this.tips[--this.currentTipIndex], 'prev');
      return this;
    }

    Tutorial.prototype.restart = function() {
      this.currentTipIndex = -1;
      this.started = false;
      this.tutorialStarterDisplayed = false;
      ns.instances.app.deleteTutorialCookies();
      $(w).off('beforeunload');
      ns.publish('tutorialrestarted', [this]);
      return this;
    }

    Tutorial.prototype.updateTutorialList = function() {
      if (!!this.options.to_view) {
        var listElement = $('#hermes-tutorial-starter-' + this.id),
            totNewElement = listElement.parents('.hermes-available-tutorials').find('> div .label-success > span'),
            totNew = ~~totNewElement.text().trim()
        ;
        listElement.find('.label-success').remove();
        listElement.find('.hermes-already-viewed-label').remove();
        listElement.find(' > span').append($('<span class="hermes-already-viewed-label"><b>(' + ns.labels.alreadyViewed + ')</b></span>'));
        if (totNew > 1) {
          totNewElement.text(totNew-1);
        } else {
          totNewElement.parent().remove();
        }
      }
    }

    Tutorial.prototype.end = function(skip) {
      this.currentTipIndex = -1;
      this.started = false;
      this.tutorialStarterDisplayed = false;
      !skip && this.updateTutorialList();
      ns.instances.app.deleteTutorialCookies();
      $(w).off('beforeunload');
      ns.publish('tutorialended', [this.options.url, skip]);
      return this;
    }

    Tutorial.prototype.start = function() {
      if (this.started || ns.activeTutorial instanceof Tutorial) {
        return;
      }
      if (ns.utils.strip(this.welcome) !== ""
          && (!this.tutorialStarterDisplayed)
          && this.currentTipIndex === -1
          && ns.instances.app.mode !== 'started-tutorial') {
        this.tutorialStarterDisplayed = true;
        ns.display({type: 'tutorialStarter', tutorial: this});
      } else {
        this.started = true;
        $(w).on('beforeunload', ns.utils.onBeforeUnloadTutorialFn);
        ns.publish('tutorialstarted', [this]);
        this.next();
      }
      return this;
    }

    Tutorial.prototype.initStarted = function(startedOptions) {
      var url = this.options.retrieveTutorialUrl.replace('{{tutorial_id}}', startedOptions.tutorialId);
      $.ajax(ns.host + url, {
        dataType: 'jsonp',
        success: function(data) {
          var tipIndex = null;
          if(data.length === 0) {
            ns.publish('tutorialdeleted');
          } else {
            $.extend(this.options, data[0]);
            this.init(startedOptions.tipIndex);
          }
        }.bind(this)
      });
    }

    Tutorial.prototype.init = function(tipIndex) {
      var startElement = null;
      this.id = this.options.id;
      this.currentTipIndex = tipIndex ? tipIndex-1 : -1;
      this.tips = this.options.tips;
      this.selector = this.options.selector;
      this.title = this.options.title;
      this.welcome = this.options.welcome;
      this.tutorialStarterDisplayed = false;
      this.tips.forEach(function(tip){
        tip.tutorial_ref = this;
      }.bind(this));
      if (this.selector) {
        startElement = $(this.selector).first();
        startElement && startElement.on('click', this.start.bind(this));
        tipIndex && this.start();
      } else {
        this.start();
      }
      return this;
    }

    ns.Tutorial = Tutorial;

  })(window, __hermes_embed);

};