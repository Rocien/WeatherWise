# WeatherWise

WeatherWise is a weather application built using Swift and SwiftUI. The app provides current weather information and a 5-day forecast for selected cities. Users can search for cities, view weather details, and manage their city lists. The app leverages OpenWeatherMap's API for real-time weather data and additional city data through the CountriesNow API.

## Features

- **Weather Information**: Displays current temperature, weather description, and other details for added cities.
- **Search Functionality**: Allows users to search for cities and add them to their list.
- **City Management**: Users can reorder and delete cities from the list.
- **Dynamic Icon Colors**: Weather icons change color based on weather conditions.
- **Detailed View**: Includes a multi-day forecast for selected cities.
- **Dark Mode Support**: The app supports dark themes with seamless UI transitions.

## API Key Management

### OpenWeatherMap API
To use the OpenWeatherMap API, an API key is required. The app currently uses a placeholder API key.

1. Visit [OpenWeatherMap](https://openweathermap.org/) and create an account.
2. Generate an API key in the dashboard.
3. Replace the placeholder API key in `WeatherService.swift`:
   ```swift
   let apiKey = "your_openweather_api_key"
   ```

### CountriesNow API
The CountriesNow API is used to fetch city names and population data. This API does not require an API key and is integrated directly within the app.

## Assumptions

- **Network Connectivity**: The app assumes the device has an active internet connection for fetching data.
- **Data Accuracy**: The app relies on the accuracy of the data provided by OpenWeatherMap and CountriesNow APIs.
- **City Data**: Only valid city names will return results; incorrect or invalid city names will prompt an error message.

## Additional Features

- **Search Suggestions**: Popular cities are displayed for quick selection.
- **Error Handling**: Errors such as invalid API responses or network issues are gracefully handled with user alerts.
- **Animations**: Smooth animations are implemented when adding or reordering cities.

## How to Run the App

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Replace the placeholder API key in `WeatherService.swift` with your OpenWeatherMap API key.
4. Run the app on an iOS simulator or a connected device.

## Future Enhancements

- **User Authentication**: Allow users to save their city lists across devices using cloud sync.
- **Hourly Forecast**: Provide hourly weather details for selected cities.
- **Localization**: Add support for multiple languages.

---

Thank you for using WeatherWise! For any questions or issues, please reach out to me.

## Author

Rocien Nkunga  
Mobile app. Developer

Email: [contact@rociennkunga.com](mailto:contact@rociennkunga.com)  
GitHub: [https://github.com/Rocien](https://github.com/Rocien)  
LinkedIn: [www.linkedin.com/in/rociennkunga](www.linkedin.com/in/rociennkunga)
Website: [https://www.rociennkunga.com/](https://www.rociennkunga.com/)

