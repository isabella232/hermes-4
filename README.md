Hermes, by IFAD
------

![hermes](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/hermes.png)

This app allows site owners to insert help elements in their site: tooltips,
banners, tutorials.

It works by requesting the embed of a `.js` file in the site, and then it
establishes a channel through which, for each page load a payload
is requested from the app, that describes the help elements to display in
that specific page.

Help elements can be:

* tips
* broadcasts
* tutorials

## How to setup Hermes

Hermes is a Rails 4 app so it will be that easy to run it:

`git clone https://github.com/ifad/hermes.git`, run `bundle`, create your database configuration and then start the server running `rails s`. Done!

## How to use Hermes

1. Add new site

	![add new site](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_site.png)

2. Once you added a site, remember to include the script on your page(s)
  * Dynamically:
  
  	`
      (function(d,l,s){s=d.createElement('script'),l=d.scripts[0];s.setAttribute('id','hermes_script_embed');s.setAttribute('data-ref','example.com');s.src='http://localhost:3001/assets/hermes.js';l.parentNode.insertBefore(s,l)}(document));
    `

  * Or in the static old way:
  
    `<script src="http://localhost:3001/assets/hermes.js" id="hermes_script_embed" data-ref="example.com"></script>`


3. Then, BOOM! You can finally create:

  * Tips: they will be shown to your visitors until they dismiss them. They can be bound to particular elements or they can be shown as broadcasts.
  
    ![add new tip](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_tip.png)
    
    ![all tips](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/all_tips.png)
  * Tutorials: collections of tips/broadcasts that will be shown to the visitors sequentially.
  
    ![add new tutorial](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_tutorial.png)
    
  * General broadcasts: add the same broadcast for each website you own
  
    ![add new general broadcast](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_general_broadcast.png)

4. Happy delivery, by Hermes! :)


## License

Hermes is released under MIT. See LICENSE.md for more information.

## Contributing

Please follow [these rules](https://guides.github.com/activities/contributing-to-open-source/)
