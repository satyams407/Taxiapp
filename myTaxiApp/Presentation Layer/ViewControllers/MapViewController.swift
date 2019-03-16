//
//  ViewController.swift
//  myTaxiApp
//
//  Created by Satyam Sehgal on 09/03/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import UIKit
import MapKit

@objc public protocol UpdateTableDelegate: class {
   @objc func reloadTable()
}

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView?
    weak var vehicleListVC: VehicleListViewController?
    let mapViewModel = MapViewModel()
    let fetchService = FetchVehicleService()
    var vehicleDataSource: [PoiList]?
    var hasFirstTimeFetched = false
    @objc open weak var updateTableDelegate: UpdateTableDelegate?
    typealias Coordinate = AppConstants.DefaultCoordinates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView?.delegate = self
        mapViewSetup()
        fetchVehicles()
    }
    
    @IBAction func showListButtonAction(_ sender: UIButton) {
        if let vehicleListVC = Utility.instantiate(viewController: AppConstants.vechileListVC) as? VehicleListViewController {
            self.present(vehicleListVC, animated: true) {
                let array = NSMutableArray.init(array: self.vehicleObjects()!)
                vehicleListVC.vehicleDataSource = array
                vehicleListVC.vehicleListTableView?.reloadData()
            }
        }
    }
    
    func mapViewSetup() {
        let coordinate = CLLocationCoordinate2D(latitude: Coordinate.latitude.rawValue, longitude:  Coordinate.longitude.rawValue)
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0.5)
        mapView?.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
        mapView?.setCenter(coordinate, animated: true)
        mapView?.camera.altitude *= 0.5
    }
    
    func fetchVehicles() {
        guard let mapBounds = mapView?.getBounds() else {
            fatalError("Unable to the getbounds of mapview")
        }
        
        fetchService.fetchVehicle(with: .fetch(mapBound: mapBounds)) { [weak self] (result) in
            guard let `self` = self else { return }
            self.hasFirstTimeFetched = true
            switch (result) {
            case .failure(let error):
                self.showErrorAlert()
                print(error)
            case .success(let data):
                if let vehicleModel = VehicleModel.init(data: data) {
                    self.vehicleDataSource = vehicleModel.poiList
                }
                DispatchQueue.main.async {
                    self.plotAnnotations()
                }
            }
        }
    }
    
    func showErrorAlert() {
        Utility.showAlert(message: "Unable to fetch the vehicles", onController: self)
    }
    
    func vehicleObjects() -> [VehicleObject]? {
        guard let poiList = vehicleDataSource else {return nil}
        return poiList.map({VehicleObject(id: $0.id, fleetType: $0.fleetType)})
    }
    
    func updateTableAndDataSource(with vehicleObjects: [VehicleObject]) {
//        let objects = VehicleListCellModel.init(store: vehicleObjects)
//        let array = NSMutableArray.init(object: objects)
//        vehicleListVC?.vehicleDataSource = array
//        self.updateTableDelegate?.reloadTable()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if hasFirstTimeFetched {
            fetchVehicles()
        }
    }
    
    func plotAnnotations() {
        // Firstly reset all the annotations
        mapView?.removeAnnotations((mapView?.annotations)!)
        guard let annotationsArray = mapViewModel.getAnnotations(with: vehicleDataSource) else {
            return
        }
        vehicleListVC?.expandbleButton?.setImage(UIImage(named: "taxi"), for: .normal)
        mapView?.addAnnotations(annotationsArray)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "taxi")
        
        if let annotationView = annotationView {
            annotationView.image = UIImage(named: "horizontalBar")
            vehicleListVC?.expandbleButton?.setImage(UIImage(named: "taxi"), for: .normal)
        }
        return annotationView
    }
}
