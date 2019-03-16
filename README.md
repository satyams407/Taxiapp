# Taxiapp
Code Structure and Technical Document


Swift language Code - All Map related code for eg MapViewController, MapViewModel,Network layer code.
Objective C code - Vehicle View Controller,Table cell, Cell Model 


Architecture - MVVM has been followed properly and efficiently

ViewControllers - 
 Mapviewcontroller.swift - It’s a initial view controller which handles api calls, all ui stuff and mapview methods and present the list detail view controller

VehicleListViewController.m - UI handling and table handling with filtering of data on fleet type.



ViewModel -
1. MapViewModel.swift -
              func getAnnotations(with vehicleList: [PoiList]?) -> [MKAnnotation]?

2. VehicleModel.swift  - Codable class that initializes after taking json response from api.


Testing 
NetworkLayerTest-  func  testEncoding()
VehicleModelTest - func testModelIntialisationFailure()
MapViewModelTests - testGetAnnotationsSuccess(), testGetAnnotationsFailure()
