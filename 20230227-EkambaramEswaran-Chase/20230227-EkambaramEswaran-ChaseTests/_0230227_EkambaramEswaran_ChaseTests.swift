//
//  _0230227_EkambaramEswaran_ChaseTests.swift
//  20230227-EkambaramEswaran-ChaseTests
//
//  Created by Ekambaram E on 2/27/23.
//

import XCTest
@testable import _0230227_EkambaramEswaran_Chase

final class _0230227_EkambaramEswaran_ChaseTests: XCTestCase {
    
    var weatherViewModel: WeatherViewModel?
    var mockNetworkManage: MockNetworkManager?
    var networkManger: NetworkManager?
    var homeVC = HomeViewController()
    var detailVC = DetailViewController()
    var searchVC = SearchResultViewController()
    
    override func setUp() {
        super.setUp()
    
        if let homeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            homeVC.navigateToDetailViewController()
            homeVC.updateRecentlySearchResult(keySearch: "Chicago")
            homeVC.refreshTableView()
            homeVC.tableView.didAddSubview(UIView())
            homeVC.loadView()
        }
        
        if let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.updateUI()
            detailVC.viewDidLoad()
            detailVC.loadView()
        }
        
        let searchVC = SearchResultViewController()
        searchVC.searchBarCancelButtonClicked(UISearchBar())
        searchVC.searchBarTextDidEndEditing(UISearchBar())
    }
    
    func testViewModel() throws {
        
        //Given
        mockNetworkManage = MockNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager: mockNetworkManage ?? MockNetworkManager())
        mockNetworkManage?.responseModel = WeatherResponseModel(coord: Coord(lon: 10.99, lat: 44.34), base: "stations", main: Main(temp: 271.98, feels_like: 271.98, temp_min: 270.52, temp_max: 270.52, pressure: 1021, humidity: 93), wind: Wind(speed: 0.67, deg: 337), clouds: Clouds(all: 100), sys: Sys(country: "IT", sunrise: 1677477465, sunset: 1677517218), name: "Zocca")

        //When
        weatherViewModel?.makeServiceCall(keySearch: "Chicago")
        
        //Then
        XCTAssertEqual(self.weatherViewModel?.responseModel?.name, "Zocca")
        
    }
    
    func testCoreLocation() throws {
        
        //Given
        let expectation = expectation(description: "FetchCore location")
        let coreLocation = CoreLocationManager()
        //When
        coreLocation.fetchLatLonBySearch(cityName: "Chicago") { lat, lon in
            //Then
            XCTAssertNotNil(lat)
            XCTAssertNotNil(lon)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    func testWeatherUI() throws {
        let view = WeatherUI.fromNib()
        XCTAssertNotNil(view)
    }
    
    func testBaseURL() throws {
        XCTAssertNotNil(URL.weatherApiURL(lat: "12.00", lon: "14.77"))
    }
    func testFetchWeatherCustomUI() throws {
        let view = WeatherCustomUI()
        XCTAssertNotNil(view.body)
        XCTAssertNil(weatherViewModel?.fetchWeatherCustomUI())
    }
    
    func testFetchUtilityCelsius() throws {
        XCTAssertNotNil(Utility.fetchCelsius(k: 233.0))
    }
    
    func testSaveLastSearchResult() throws {
        XCTAssertNotNil(Utility.saveLastSearchResult(array: ["Chicago", "New york"]))
    }
    
    func testFetchLastSearchResult() throws {
        XCTAssertNotNil(Utility.fetchLastSearchResult())
    }
    
    func testNetworkManagerCall() throws {
        let expectation = expectation(description: "Fetch API")
        networkManger = NetworkManager()
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=5dd5000d347c9095f61d9d75f37f0b5c") {
            networkManger?.fetchAPIService(url, model: WeatherResponseModel.self) { result in
                XCTAssertNotNil(result)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2.0)
    }
    
    func testFetchWeather() throws {
        let expectation = expectation(description: "Fetch API")
        networkManger = NetworkManager()
        networkManger?.fetchWeatherInfo(keySearch: "Chicago") { lat, lon in
            XCTAssertNotNil(lat)
            XCTAssertNotNil(lon)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    
    func testFetchCelsius() throws {
        //Given
        mockNetworkManage = MockNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager: mockNetworkManage ?? MockNetworkManager())
        mockNetworkManage?.responseModel = WeatherResponseModel(coord: Coord(lon: 10.99, lat: 44.34), base: "stations", main: Main(temp: 271.98, feels_like: 271.98, temp_min: 270.52, temp_max: 270.52, pressure: 1021, humidity: 93), wind: Wind(speed: 0.67, deg: 337), clouds: Clouds(all: 100), sys: Sys(country: "IT", sunrise: 1677477465, sunset: 1677517218), name: "Zocca")

        //When
        weatherViewModel?.makeServiceCall(keySearch: "Chicago")
        
        //Then
        XCTAssertNotNil(weatherViewModel?.fetchCelsius())
        XCTAssertNotNil(weatherViewModel?.fetchCelsius(isLocationBasedWeather: true))
    }
    
    func testFetchImageURL() throws {
        //Given
        mockNetworkManage = MockNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager: mockNetworkManage ?? MockNetworkManager())
        mockNetworkManage?.responseModel = WeatherResponseModel(coord: Coord(lon: 10.99, lat: 44.34), weather: [Weather(id: 2, main: "33", description: "Chica", icon: "10n")], base: "stations", main: Main(temp: 271.98, feels_like: 271.98, temp_min: 270.52, temp_max: 270.52, pressure: 1021, humidity: 93), wind: Wind(speed: 0.67, deg: 337), clouds: Clouds(all: 100), sys: Sys(country: "IT", sunrise: 1677477465, sunset: 1677517218), name: "Zocca")

        //When
        weatherViewModel?.makeServiceCall(keySearch: "Chicago")
        
        weatherViewModel?.fetchLocationServiceCall(lat: "10.99", lon: "44.34")
        
        //Then
        XCTAssertNotNil(weatherViewModel?.fetchImageURL())
        XCTAssertNotNil(weatherViewModel?.fetchImageURL(isLocationBasedWeather: true))
    }
    
    func testFetchFeelsLike() throws {
        //Given
        mockNetworkManage = MockNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager: mockNetworkManage ?? MockNetworkManager())
        mockNetworkManage?.responseModel = WeatherResponseModel(coord: Coord(lon: 10.99, lat: 44.34), base: "stations", main: Main(temp: 271.98, feels_like: 271.98, temp_min: 270.52, temp_max: 270.52, pressure: 1021, humidity: 93), wind: Wind(speed: 0.67, deg: 337), clouds: Clouds(all: 100), sys: Sys(country: "IT", sunrise: 1677477465, sunset: 1677517218), name: "Zocca")

        //When
        weatherViewModel?.makeServiceCall(keySearch: "Chicago")
        
        //Then
        XCTAssertNotNil(weatherViewModel?.fetchFeelsLike())
        XCTAssertNotNil(weatherViewModel?.fetchFeelsLike(isLocationBasedWeather: true))
    }
    
    func testFetchHumidity() throws {
        //Given
        mockNetworkManage = MockNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager: mockNetworkManage ?? MockNetworkManager())
        mockNetworkManage?.responseModel = WeatherResponseModel(coord: Coord(lon: 10.99, lat: 44.34), base: "stations", main: Main(temp: 271.98, feels_like: 271.98, temp_min: 270.52, temp_max: 270.52, pressure: 1021, humidity: 93), wind: Wind(speed: 0.67, deg: 337), clouds: Clouds(all: 100), sys: Sys(country: "IT", sunrise: 1677477465, sunset: 1677517218), name: "Zocca")

        //When
        weatherViewModel?.makeServiceCall(keySearch: "Chicago")
        
        //Then
        XCTAssertNotNil(weatherViewModel?.fetchHumidity())
        XCTAssertNotNil(weatherViewModel?.fetchHumidity(isLocationBasedWeather: true))
    }
    
}


class MockNetworkManager: NetworkManagerProtocol {
  
    var responseModel: WeatherResponseModel?
        
    func fetchAPIService<T: Codable>(_ url: URL, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        if let responseModel = responseModel as? T {
            completion(.success(responseModel))
        }
    }
    
    func fetchWeatherInfo(keySearch: String, completion: @escaping (String, String) -> ()) {
        completion("44.34", "10.99")
    }
    
}
