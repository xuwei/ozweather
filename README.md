# ozweather
weather app using open weather api 

### Notes ###
- MVVM design pattern
- Cocoapod workspace, but for this project, didn't end up using any third party libraries
- Storyboard + XIB is used. 
- WTableVC is parent class to both WeatherSearchVC and WeatherDetailsVC as both share some common configurations like refreshControl, activity indicator, and both observer of location update
- Services classes are designed to be independend within Services group, so it's possible to move Services as a separate framework project
- OpenWeatherServices implements the weather api integration
- Didn't use extension to UIImageView to load image by URL, because this approach will have memory leak when apply onto tableview with lots of cells to scroll through, I externally load image instead and assign the image back to corresponding cell. Check usage of ImageService. 
- Alot of service and util classes is separated into protocol+implementation, so it's easy to enhance/optimise implementations later
- Unit tests and integration tests are added mostly targetting the search scenarios. 
- Due to time limitations, not much tests are not covering some util classes and logics related to Details
- WLocationService designed to notify location update by Notification events instead of direct delegate as I feel the location services can be consumed by multiple components down the track. E.g. a map view. 
