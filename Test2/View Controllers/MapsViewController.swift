//
//  MapsViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/19/21.
//

import UIKit
import YandexMapKit
import Firebase

class MapsViewController: UIViewController, YMKClusterListener{
    
    var data : Array<QueryDocumentSnapshot>?
    
    @IBOutlet weak var mapView: YMKMapView!
    
    var collection: YMKClusterizedPlacemarkCollection?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        collection?.addTapListener(with: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if data==nil{
            print("Error on segue")
        }
        else{
            fullfillPointData()
        }
    }
    
    func onClusterAdded(with cluster: YMKCluster) {
    }
    
    func fullfillPointData(){
        for map_data in data!{
            let point=YMKPoint(latitude: map_data.data()["latitude"] as! Double, longitude: map_data.data()["longitude"] as! Double)
            let placemark = collection?.addPlacemark(with: point,
            image: UIImage(systemName:  "mappin")!, style: YMKIconStyle.init())
            placemark?.userData = map_data
        }

        collection?.clusterPlacemarks(withClusterRadius: 5, minZoom: 15)
    }
    
    func transitionToDetailed(_ detailedData: QueryDocumentSnapshot) {
        
        let detailedViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.detailedViewController) as? DetailedViewController)!
        let tableViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tableViewController) as? TableViewController)!
        let navViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController
        detailedViewController.data=detailedData
        navViewController?.pushViewController(tableViewController, animated: true)
        navViewController?.pushViewController(detailedViewController, animated: true)
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
        
    }
   
}

extension MapsViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let userPoint = mapObject as? YMKPlacemarkMapObject else {
            return true
        }
        print(userPoint.userData!)
        transitionToDetailed(userPoint.userData! as! QueryDocumentSnapshot)
        return true
    }
}



