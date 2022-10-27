# Terra
iOS app for soil studying. Given a specific map location, this app shows vegetation index through satellite captures, clouds and weather forecasts, soil moisture, soil temperature, among others. 

Concepts:

* MapKit
* Generics
* SwiftCharts
* XCTest
* Delegate pattern
* Protocols and extensions
* Parse JSON with the native Encodable and Decodable protocols


## Architecture Diagram

![Screen Shot 2022-10-26 at 5 05 13 PM](https://user-images.githubusercontent.com/99278919/198147476-9f89cfb1-3c54-4d47-988f-2a20ee577f13.png)

## Instructions
### 1. Fields

The first screen shows a list of monitoried fields. The final user can select the one he want in order to check vegetation index, moisture or soil data:

![Screen Shot 2022-10-26 at 5 13 06 PM](https://user-images.githubusercontent.com/99278919/198148569-3bc58ea2-fd2c-415a-af7c-23c9c63a8ca6.png)


### 2. Select Field

Select one of the fields from the list. It will be localized over the map, showing its latitude, longitude, and area:

![ezgif com-gif-maker (10)](https://user-images.githubusercontent.com/99278919/198189657-bfdfdc6e-1165-40af-928d-f06c9ee281bb.gif)


### 3. NDVI

Get the Normalized difference vegetation index (NDVI) for the selected field: A satellite image to recognize how fertile the field is. Besides this, the user gets information about the satellite that captured the image: Azimut, elevation, data coverage, and cloud coverage:

![ezgif com-gif-maker (11)](https://user-images.githubusercontent.com/99278919/198192200-cd93f57d-b523-4dc7-9f07-3b095bbed7e0.gif)


### 4. Forecast

This functionality predicts the temperature and cloud coverage for the selected field during the next week:

![ezgif com-gif-maker (12)](https://user-images.githubusercontent.com/99278919/198192614-b8ae56bc-63b4-436c-aab4-34eb108e209b.gif)


### 5. Soil

Get the current soil temperature on the 10 centimeters depth, surface temperature, and soil moisture:

![ezgif com-gif-maker (13)](https://user-images.githubusercontent.com/99278919/198192831-c59ea2ad-6189-4abc-b27d-99c572ff7e99.gif)
