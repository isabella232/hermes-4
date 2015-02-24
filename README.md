Hermes, by IFAD
---------------

[![Build Status](https://travis-ci.org/ifad/hermes.svg?branch=master)](https://travis-ci.org/ifad/hermes)

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

Hermes is a Rails 4 app that requires either a Postgres, MySQL or SQLite3 database.
For SQLite3, the [PCRE extension](https://github.com/ralight/sqlite3-pcre) is
required, that can usually be found by installing the sqlite3-pcre package of your
operating system distribution.

* Get the code: `git clone https://github.com/ifad/hermes.git`
* Install dependencies: `bundle`
* Run setup tasks: `rake hermes:setup`
* Start the server: `rails server`

## How to use Hermes

1. Add a new site. We will add `example.com`

	![add new site](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_site.png)

2. Once you added that site, remember to include the hermes embedded script on your page(s). You can include it:
  * Dynamically:

  	```js
      (function(d,l,s){s=d.createElement('script'),l=d.scripts[0];s.setAttribute('id','hermes_script_embed');s.setAttribute('data-ref','example.com');s.src='//your-hermes-server/assets/hermes.js';l.parentNode.insertBefore(s,l)}(document));
    ```

  * Or in the static old way:

    ```html
      <script src="//your-hermes-server/assets/hermes.js" id="hermes_script_embed" data-ref="example.com"></script>
    ```

    **note**: The snippets above are just a demonstration, for each website you will add to hermes a new snippet to add to your pages is created and it will be shown once the site is created!

3. Then, BOOM! You can finally create:

  * Tips: they will be shown to your visitors until they dismiss them. They can be bound to particular elements or they can be shown as broadcasts. To bound them you will be able to open `example.com` on hermes' `authoring mode` and you will be able to select elements inside of that webpage. It's surely easier to do it than to explain it!

    ![add new tip](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_tip.png)

    ![all tips](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/all_tips.png)

  * Tutorials: collections of tips/broadcasts that will be shown to the visitors sequentially. They can also be multipage!

    ![add new tutorial](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_tutorial.png)

  * General broadcasts: add the same broadcast for each website you own

    ![add new general broadcast](https://raw.githubusercontent.com/ifad/hermes/master/screenshots/add_general_broadcast.png)

4. When you (or some user) visit `example.com` or a path on that domain where you have defined some tips/tutorial, you will be able to see all the messages you have created with the awesome Hermes.

5. Happy delivery, by Hermes! :)


## License

Hermes is released under MIT. See LICENSE.md for more information.

## Contributing

Please follow [these rules](https://guides.github.com/activities/contributing-to-open-source/)
