# Elm Demo

[Check Out The End Result](https://stoykostanchev.github.io/elm-products/build)

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app). For additional information such as how to build the project, as well as a list of available commands and other features - feel free to visit the tool's website.

# Thoughts

For this project I have chosen to use Elm. Some of my regrets would include the not-so-nice looking update function in ```src/Main.elm```. Another one would be having a single model for the product - there are 2 logical models. Reusing the decoders turned out not so trivial for me, left splitting for later, and never got around to it.

From the start I had an idea of a theme + being able to modify that theme at runtime. My thought process was - if I am going to try and make the UI attractive, I will be spending time tweaking colors. If I can tweak them dynamically, I might get faster feedback, and it would make for a nice side feature to show. Ultimately though, I decided not to go with it, mostly because of the boilerplate I think I would have to write for each property of the theme. I could not think of a smarter way of doing this in Elm, so moved on and did not revisit. However, since I had the base down, I decided to implement a second theme + a switch between them.

I am re-reading the initial task. I might've made a mistke by putting a button on the list of cars, however having spent so much time on this already I am reluctant to just remove it. Plus I think that's one of the few elements on the page I have colored, and I would be sad to remove it.

In terms of code - I have not written any tests, I don't think those would have helped me much (except maybe for a sanity check that the project builds before committing)

When I started doing this task, I knew I wanted to convert the scetches to something that resembles a more concrete mockup, to get a better idea of what data I have available, and what the concrete structure / text would be.

I decided on giving Elm.css a try, the idea of type safe css is tempting. I did throw in some things (e.g. animation and globals) inside a css file initially, until I got used to the syntax. I considered Elm-ui / raw css and scss.

I've used gh-pages. Hosting the project there had some caveats which I had to tackle before I could submit - routing in particular. I've hacked / worked around those issues in the gh-pages branch.

