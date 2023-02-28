//
//  ViewController.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import CoreLocation
import UIKit

class HomeViewController: UIViewController {
    
    var searchController: UISearchController?
    var viewModel: WeatherViewModel = WeatherViewModel()
    var searchResultViewController = SearchResultViewController()
    var locationManager: CLLocationManager = CLLocationManager()
    var weatherUI: WeatherUI = WeatherUI.fromNib() ?? WeatherUI()
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        initLocationService()
        updateResult()
        updateLocationResult()
    }
    
    func updateResult() {
        viewModel.updateResponse = {
            DispatchQueue.main.async {
                self.refreshTableView()
                if let _ = self.viewModel.responseModel {
                    self.navigateToDetailViewController()
                } else {
                    //TODO: handle the failure scenario
                }
            }
        }
    }
    
    func updateLocationResult() {
        viewModel.updateLocationResponse = {
            DispatchQueue.main.async {
                if let _ = self.viewModel.currentLocationModel {
                    self.updateLocationWeatherUI()
                } else {
                    //TODO: handle the failure scenario
                }
            }
        }
    }
    
    func updateLocationWeatherUI() {
        if let url = viewModel.fetchImageURL(isLocationBasedWeather: true) {
            weatherUI.imageView?.kf.setImage(with: url)
        } else {
            //TODO: show the default image
        }
        weatherUI.temp?.text = viewModel.fetchCelsius(isLocationBasedWeather: true)
        weatherUI.feelsLikeLabel?.text = viewModel.fetchFeelsLike(isLocationBasedWeather: true)
        weatherUI.humidityLabel?.text = viewModel.fetchHumidity(isLocationBasedWeather: true)
    }
    
    func navigateToDetailViewController() {
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            destinationVC.weatherViewModel = viewModel
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        title = "Weather"
        tableView.delegate = self
        tableView.dataSource = self
        weatherUI.frame = CGRectMake(0, 0, view.bounds.width, 200);
        tableView.tableFooterView = weatherUI
        tableView.isScrollEnabled = false
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        var cellContext = cell.defaultContentConfiguration()
        cellContext.text = viewModel.recentSearches?[indexPath.row] ?? ""
        cell.contentConfiguration = cellContext
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let searchKey = viewModel.recentSearches?[indexPath.row] ?? ""
        viewModel.makeServiceCall(keySearch: searchKey)
    }
}


//MARK: SearchResultDelegate
extension HomeViewController: SearchResultDelegate {
    
    private func setupSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController?.showsSearchResultsController = true
        searchResultViewController.delegate = self
        navigationItem.searchController = searchController
        let searchBar = searchController?.searchBar
        searchBar?.delegate = searchResultViewController
        searchBar?.clipsToBounds = true
        searchBar?.layer.cornerRadius = 5
        searchBar?.isTranslucent = false
        searchBar?.backgroundColor = .white
    }
    
    func updateRecentlySearchResult(keySearch: String) {
        if keySearch.count > 0 {
            viewModel.recentSearches?.append(keySearch)
            Utility.saveLastSearchResult(array: viewModel.recentSearches ?? [])
            viewModel.makeServiceCall(keySearch: keySearch)
        }
    }
    
    func refreshTableView() {
        self.tableView.reloadData()
    }
}


//MARK: CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func initLocationService() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        let lat = String(userLocation.coordinate.latitude)
        let lon = String(userLocation.coordinate.longitude)
        
        if lat.count > 0, lon.count > 0 {
            viewModel.fetchLocationServiceCall(lat: lat, lon: lon)
        }
    }
}
