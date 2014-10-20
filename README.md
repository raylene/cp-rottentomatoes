## Rotten Tomatoes

This is a movies app displaying movies and DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Displayed movies = box office movies.
Displayed DVDs = current releases.

Time spent: 6hr

### Features

#### Required

- [X] User can view a list of movies. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees error message when there is a network error: http://cl.ly/image/1l1L3M460c3C
- [X] User can pull to refresh the movie list.

#### Optional

- [ ] All images fade in.
- [X] For the larger poster, load the low-res first and switch to high-res when complete. [NOTE: I'm not 100% sure how to do this, but I managed to do this by just calling setImageWithURL 2x... :/]
- [ ] All images should be cached in memory and disk: AppDelegate has an instance of `NSURLCache` and `NSURLRequest` makes a request with `NSURLRequestReturnCacheDataElseLoad` cache policy. I tested it by turning off wifi and restarting the app.
- [ ] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.
- [X] Add a tab bar for Box Office and DVD. [NOTE: Still missing custom icons]
- [ ] Add a search bar: pretty simple implementation of searching against the existing table view data.

### Walkthrough

Walkthrough, Sunday 10pm
* Basic features: http://i.imgur.com/eNPzXzr.gif
* Network error: http://i.imgur.com/7X7NrRz.gif

![Video Basic](http://i.imgur.com/eNPzXzr.gif)
![Video Network Error](http://i.imgur.com/7X7NrRz.gif)

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [Customizing Navigation Bar](http://www.appcoda.com/customize-navigation-status-bar-ios-7/)

