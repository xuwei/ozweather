# ozweather
weather app using open weather api 

### Notes ###
- MVVM design pattern

- Cocoapod workspace, but for this project, didn't end up using any third party libraries. 

- Storyboard + XIB is used. I felt most confident with this approach for bootstrapping the app. Storyboard could be replaced with programmatically created Views easily as all controllers are TableViewControllers with a common parent. But ran out of time. 

- Traditional use of delegate pattern for cell callbacks. 

- WTableVC is parent class to both WeatherSearchVC and WeatherDetailsVC as both share some common configurations like refreshControl, activity indicator, and observer for location update events. 

- Services classes are designed to be independend within Services group, so it's possible to move Services as a separate framework project.

- OpenWeatherServices implements the weather api integration. 

- Didn't use extension to UIImageView to load image by URL, because this approach will have memory leak when apply onto tableview with lots of cells to scroll through, I externally load image instead and assign the image back to corresponding cell. Check usage of ImageService. A cache can be added to improve loading performance, as the amount of icons are limited by types of weather.

- Alot of service and util classes is separated into protocol+implementation, so it's easy to enhance/optimise implementations later.

- Unit tests and integration tests are added mostly targetting the search scenarios. 

- Due to time limitations, not much tests are not covering some util classes and logics related to Details. My test strategy is to test the fundamental logics first from services, util, viewModels. 

- WLocationService designed to notify location update by Notification events instead of direct delegate as I feel the location services can be consumed by multiple components. Foreground + Background. 
