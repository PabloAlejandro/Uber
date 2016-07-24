# Uber

- Utils

JsonRequest folder contains classes for managing the json request. When the request fails it keeps trying, increasing an interval, until it gets a response. I suggest adding some extra checks before retrying again (ie. network connection available).

In Network we can find a simple library I built some time ago in order to retrieve data from a server async. This library includes a wide collection of properties the developer can set in order to configure the request. Note most of the properties aren't required for this task, but the library is useful in case we need to request a different server which requires authentication processes and extra fields on the http headers.


- Uber

The app is based on two view controllers, the main one (DashboardViewCotnroller) which manages the json request and sets the collection view, and a second one (HistoryViewController) which is an UITableViewController responsible for the search history. Aditionally, we have a helper class (DashboardCollectionController) which implements delegates and data source fo the collection view and sends the events back to its parent view controller (DashboardViewCotnroller).

Images are downloaded async in ImageDownloader class, and it notifies its delegate (DashboardCollectionController) once downloaded. Once the delegate gets the downloaded image it saves it in a temporal cache (a NSDictionary with the image as value and the photo id as key). I strongly recommend using the library SDWebImage https://github.com/rs/SDWebImage, (also available on Cocoapods https://cocoapods.org/pods/SDWebImage), which makes the "hard work" of downloading and caching images. In this task I prefered just to show how to easily implement a proper system for image downloading, using delegates, on a collection view cell (also applies for table view cells). Note, we could have used blocks instead if we wanted.

IMPORTANT NOTE: I am perfectly conscient caching images in memory is not a good solution, images should be stored persistently on disk instead. The caching implementation on this task is just to simulate the behaviour of a caching system, where images don't need to be downloaded again when scrolling once downloaded. But it should be implemented persistently on disk (this is just a dev test, I wouldn't use it on production).

Regarding to the pagination, the UIScrollViewDelegate (from the collection view) detects when the collection has reached the bottom side and notifies the class delegate (DashboardViewCotnroller). Once the delegate gets the call, it starts a new request with the next page of the previous search.

Since the history is a really limited and simple data (up to 30 strings), it's been implemented to be saved in NSUserDefaults. When the history gets higher than the maximum allowed it discards the oldest searches. Since we haven't been told the opposite, history supports duplicates and it's sorted by date, that's why we use and NSArray instead of a NSSet. 
