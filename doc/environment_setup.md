# Environment Setup

## Setup Google Maps API Key

To get your own Google Maps API key you can get it [here](https://developers.google.com/maps/get-started#quickstart).

- **Web**
   For local development web, create a local version of `web/env.js` with your
   development API key:

   ```js
   window.ENV = {
     GOOGLE_MAPS_API_KEY: 'YOUR_API_KEY'
   };
   ```

- **Android**
   Add your api on `android\app\src\main\AndroidManifest.xml`

   ```xml
   ...
   // TODO: Add your Google Maps Api Key here
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY" />
   ...
   ```

- **iOS**
   Add your api on `ios\Runner\AppDelegate.swift`

   ```swift
   ...
   // TODO: Add your Google Maps Api Key here
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ...
   ```

## Setup Geocode API Key

To get your own Geocode API key you can get it [here](https://geocode.maps.co/).

For setup, create file `assets/.env` and put your own Geocode API key:
  
```env
GEOCODE_API_KEY='YOUR_API_KEY'
```
