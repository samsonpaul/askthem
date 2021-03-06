# Notes on how to add widget-builder widget to askthem code base

In askthem's repo, the public/widgets directory is a bit different. It is for
static JS widgets.

However, some of these widgets are developed first as standalone Ember.js apps.
In order for them to be distributable as widgets from http://askthem.io though,
we need to build them, take the "concoction" (a sort of template for the app),
and its assets and put them manually into the askthem repo's codebase.

In addition, we may need to adjust some hardcoded values in the  jquery loader
(public/widgets/widget-builder/widget.js in this case) .

Convoluted, but it gives a lot of flexibility that we need to be able to
configure with different settings via simple html and be able to have multiple
instances of the widget on a page.

Anywho, here are the steps to set up the widget-builder widget for distribution
via AskThem.io:

* in your local clone of the [widget-builder-widget](https://github.com/opengovernment/widget-builder-widget), run a build like so:

```
cd widget-builder-widget
mkdir production # or rm -rf production/* if it already exists
ember build -e production -o production
```

 The build will give you three things you need, the
 widget-builder-widget-concoction.txt file, the corrsponding production/assets
 directory which has files the app relies on, and an index.html which
 you will base your meta config/environment meta tag on.

* first copy widget-builder-widget-concoction.txt file to
public/widgets/widget-builder/app-concoction.txt under you askthem repo

* next copy the build's assets file contents to under
public/widgets/widget-builder/assets/ - you can skip widget-builder-widget-...js file, but you want
widget-builder-widget-...css as well as both vendor files (css and js)

Something like this should do the trick (your paths may need tweaking):
```
cp production/assets/*.css ../../apps/askthem/public/widgets/widget-builder/assets/
cp production/assets/vendor-*.js ../../apps/askthem/public/widgets/widget-builder/assets/
```

* we need to then edit public/widgets/widget-builder/widget.js with a number of values,
we'll start with the assets files we just copied over:

Open public/widgets/widget-builder/widget.js in a text editor. Search for "var cssUrls"
and edit the listed files to match css files now under
pubic/widgets/widget-builder/assets/ (changing the hash string just before the ".css"
should do the trick).

Search for "var jsUrls" and do the same for the vendor JavaScript file.

* one more edit to widget.js, we need to update the config/environment meta tag
template.

_Note:_ *you only have to do this step if the widget-builder widget project's
config/environment.js has been edited since the last time you updated
askthem/public/widgets/widget-builder. Check commit history for the file to see.*

This can be tricky and is the hardest step.
  * back in the widget-builder-widget repo, open the production/index.html from our build
  * notice the meta tag with name "widget-builder-widget/config/environment"? copy the *content*
  from that tag to some temporary location where you can edit it
  * search and replace the string "%22widget-builder-widget%22" with "%22' + tagId + '%22" in
  the content you copied in its temporary location
  * search and replace the string "%23widget-builder-widget-container" with
   "%23'+ tagId +'-container" in the content you copied in its temporary location
* back in the widget.js file in your text editor, find the function call that starts with this:
  "_createMetaTag(tagId + '/config/environment',"
  * replace the *2nd* argument to this function call with the *new* content with
  "tagId" in it in widget.js

* if you have doing development based on a local dev server and have
  changed hostname for resources to something other than under
  www.askthem.io, make sure to change it back!

* last, commit your changes, push them, and deploy

Your changes to the widget-builder widget is now ready on http://askthem.io.
