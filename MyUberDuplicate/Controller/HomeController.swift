//
//  HomeController.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 23.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import UIKit
import Firebase
import MapKit

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier = "DriverAnnotation"

private enum ActionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
}

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var searchResults = [MKPlacemark]()
    private final let locationInputViewHeight: CGFloat = 200
    private var actionButtonConfig = ActionButtonConfiguration()
    
    private var user: User? {
        didSet { locationInputView.user = user }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
//        signOut()
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed() {
        switch actionButtonConfig {
        case .showMenu:
            print("DEBUG: Handle show menu..")
        case .dismissActionView:
            mapView.annotations.forEach { (annotation) in
                if let anno = annotation as? MKPointAnnotation {
                    mapView.removeAnnotation(anno)
                }
            }
            
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
                self.configureActionButton(config: .showMenu)
            }
        }
    }
    
    // MARK: - API
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func fetchDrivers() {
        guard let location = locationManager?.location else { return }
        Service.shared.fetchDrivers(location: location) { (driver) in
            guard let coordinate = driver.location?.coordinate else { return }
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            print("DEBUG: Driver coordinate is \(coordinate)")
            
            var driverIsVisible: Bool {
                return self.mapView.annotations.contains { annotation -> Bool in
                    guard let driverAnno = annotation as? DriverAnnotation else { return false }
                    if driverAnno.uid == driver.uid {
                        driverAnno.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                    return false
                }
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configure()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    // MARK: - Helper Functions
    
    func configure() {
        configureUI()
        fetchUserData()
        fetchDrivers()
    }
    
    fileprivate func configureActionButton(config: ActionButtonConfiguration) {
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
        case .dismissActionView:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionView
        }
    }
    
    func configureUI() {
        configureMapView()
        
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            paddingTop: 16,
                            paddingLeft: 20,
                            width: 30,
                            height: 30)
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inview: view)
        inputActivationView.setDimentions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
        
        configureTableView()
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func configureLocationInputView() {
        locationInputView.delegate = self
        
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 height: locationInputViewHeight)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0,
                                 y: view.frame.height,
                                 width: view.frame.width,
                                 height: height)
        
        view.addSubview(tableView)
    }
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.alpha = 0
            self.locationInputView.removeFromSuperview()
        }, completion: completion)
    }
}

// MARK: - Map Helper Functions

private extension HomeController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            
            response.mapItems.forEach { item in
                results.append(item.placemark)
            }
            
            completion(results)
        }
    }
}

// MARK: - MKMapViewDelegate

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        return nil
    }
}

// MARK: - LocationServices

extension HomeController {
    func enableLocationServices() {        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not determined..")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always..")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use..")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
}

// MARK: - LocationInputActivationViewDelegate

extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
}

// MARK: - LocationInputViewDelegate

extension HomeController: LocationInputViewDelegate {
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView() {
        dismissLocationView { _ in
            UIView.animate(withDuration: 0.5) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}

// MARK: - UITableViewDelegate/DataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]
        
        configureActionButton(config: .dismissActionView)
        
        dismissLocationView { _ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}
