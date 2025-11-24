//
//  MapPlacesView.swift
//  AchouFood
//
//  Created by Arthur Rios on 24/11/25.
//

import UIKit
import MapKit
import SnapKit

class MapPlacesView: UIView {
    
    private var allPlaces: [Place] = []
    private var filteredPlaces: [Place] = []
    
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
    
}
