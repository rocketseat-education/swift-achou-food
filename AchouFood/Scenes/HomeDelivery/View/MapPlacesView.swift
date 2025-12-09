//
//  MapPlacesView.swift
//  AchouFood
//
//  Created by Arthur Rios on 24/11/25.
//

import UIKit
import MapKit
import SnapKit

struct MapViewConstants {
    static let placeId = "placeId"
    static let blackPin = "blackPin"
    static let redPin = "redPin"
}

class MapPlacesView: UIView {
    
    private var allPlaces: [Place] = []
    private var filteredPlaces: [Place] = []
    
    var onPinSelected: ((Place) -> Void)?
    var onPinDeSelected: (() -> Void)?
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.showsScale = false
        view.delegate = self
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderAnnotations(from places: [Place]) {
        mapView.removeAnnotations(mapView.annotations)
        guard !places.isEmpty else { return }
        let annotationList = places.map { place in
            PlaceAnnotation(place: place)
        }
        mapView.addAnnotations(annotationList)
        
        if annotationList.count == 1, let annotation = annotationList.first {
            let region = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: 1500,
                longitudinalMeters: 1500
            )
            mapView.setRegion(region, animated: true)
            return
        }
        
        var totalArea = MKMapRect.null
        for annotation in annotationList {
            let point = MKMapPoint(annotation.coordinate)
            totalArea = totalArea.union(MKMapRect(x: point.x, y: point.y, width: 0.01, height: 0.01))
        }
        mapView.setVisibleMapRect(totalArea, edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40), animated: true)
    }
}

extension MapPlacesView {
    public func showPlaces(with places: [Place]) {
        self.allPlaces = places
        self.filteredPlaces = places
        renderAnnotations(from: places)
    }
    
    public func filter(by text: String) {
        if text.isEmpty {
            filteredPlaces = allPlaces
        } else {
            filteredPlaces = allPlaces.filter { place in
                place.restaurantName.lowercased().contains(text.lowercased())
            }
        }
        renderAnnotations(from: filteredPlaces)
    }
}

extension MapPlacesView: ViewCodeProtocol {
    func setViewHierarchy() {
        addSubview(mapView)
    }
    
    func setViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewConfigs() {
        backgroundColor = .clear
    }
}

extension MapPlacesView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: MapViewConstants.placeId) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: MapViewConstants.placeId)
        view.annotation = annotation
        view.canShowCallout = false
        view.image = UIImage(named: MapViewConstants.blackPin)
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: MapViewConstants.redPin)
        guard let annotation = view.annotation as? PlaceAnnotation else { return }
        onPinSelected?(annotation.place)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: MapViewConstants.blackPin)
        onPinDeSelected?()
    }
}
