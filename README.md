<p align="center">
  <img width="400" height="400" src="https://user-images.githubusercontent.com/23087566/139608465-2a515503-e2f6-4104-a49f-6d2065794184.png">
</p>


# AppStore - iOS

iTunesSearchApp utilizes the [Apple's iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html) to fetch app data, similar to the iOS App Store. Users can search for any app currently published on the app store. Users can filter search results by price. Users can further refine search results by category via the filter screen. Once a user is settled on search results, an app from the list can be selected, allowing users to view app details.

## Architecture

This project was developed entirely with UIKit/MVC architecture.

## Resources

This project could not have been developed without the use of [Apple's iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html)

## Running The Project

There is no initial setup needed to run the app. Open XCode, choose a simulator, and run the app!

## Customization

There is a default search set to "IBM". If desired, this can be removed. Navigate to the MainVC and look for the function "api.loadData(search: "ibm")". Users can either change the default "ibm" search parameter, or remove it altogether. Please keep the quotes, as at a minimum an empty string will need to be passed.

Users can additionally modify the number of results returned via the "API" file. Locate the following line of code "URL(string:"https://itunes.apple.com/search?term=\(search)&entity=software&limit=14")". Change the "=14" to desired value. Please note: increasing this number will delay search result return time.

## Project Features

Users can search for an application via the main view. Doing so will return a list of applications.

Users can apply a price based filter via the segmented picker at the top of the main view. 

Users can further filter results via the filter view. This allows users to filter by category (genre). 

Clicking on an app that is returned via search will bring up the app detail screen. Users can see the app image, name, price, screenshots, and description from this view.

**Please note - when a new search is performed, all filters are cleared**

## App Gifs

[My Website - Projects](https://www.nicholasrepaci.com/projects)

<p float="center">
  <img src="https://user-images.githubusercontent.com/23087566/139608396-fded0432-ddf9-41e8-9198-594b8f8e7064.gif" width="300" />
  <img src="https://user-images.githubusercontent.com/23087566/139608405-03763ad2-2250-41a1-9d10-1c48577b0000.gif" alt="animated" width="300" /> 
  <img src="https://user-images.githubusercontent.com/23087566/139608413-2fe525b5-a3e6-4ee5-a2f2-9a2174bd69d0.gif" width="300" />
</p>

## Help

Submit a [GitHub Issues request](https://github.com/nprepaci/iTunesSearchApp/issues). 

