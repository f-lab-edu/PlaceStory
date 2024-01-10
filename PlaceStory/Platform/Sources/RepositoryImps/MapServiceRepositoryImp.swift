//
//  File.swift
//  
//
//  Created by 최제환 on 1/9/24.
//

import Combine
import Entities
import Foundation
import MapKit
import Repositories
import Utils

public final class MapServiceRepositoryImp: NSObject {
    
    private var searchCompleter: MKLocalSearchCompleter
    private var searchResultsSubject = CurrentValueSubject<PlaceSearchResult, Never>(PlaceSearchResult(results: []))
    private var localSearchSubject = PassthroughSubject<PlaceRecord, Never>()
    
    public override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        super.init()
        
        configureSearchCompleter()
    }

    private func configureSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
    }
}

// MARK: - MapServiceRepository

extension MapServiceRepositoryImp: MapServiceRepository {
    public func searchPlace(from text: String) -> AnyPublisher<PlaceSearchResult, Never> {
        searchCompleter.queryFragment = text
        return searchResultsSubject.eraseToAnyPublisher()
    }
    
    public func startSearchWithLocalSearchCompletion(at index: Int) -> AnyPublisher<PlaceRecord, Never> {
        let result = searchResultsSubject.value.results[index]
        let searchReqeust = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchReqeust)
        
        search.start { [weak self] response, error in
            guard let self else { return }
            
            guard error == nil else {
                Log.error("[MKLocalSearch] error is \(error.debugDescription)", "[\(#file)-\(#function) - \(#line)]")
                return
            }
            
            guard let placeMark = response?.mapItems[0].placemark else { return }
            
            let latitude = placeMark.coordinate.latitude
            let longitude = placeMark.coordinate.longitude
            let locationTitle = result.title
            
            let placeRecord = PlaceRecord(latitude: latitude, longitude: longitude, placeName: locationTitle, placeDescription: "", placeImages: [])
            
            localSearchSubject.send(placeRecord)
        }
        
        return localSearchSubject.eraseToAnyPublisher()
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension MapServiceRepositoryImp: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        Log.info("results = \(results)", "[\(#file)-\(#function) - \(#line)]")
        let placeSearchResults = PlaceSearchResult(results: results)
        Log.info("placeSearchResults.results = \(placeSearchResults.results)", "[\(#file)-\(#function) - \(#line)]")
        searchResultsSubject.send(placeSearchResults)
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        Log.error("error is \(error.localizedDescription)", "[\(#file)-\(#function) - \(#line)]")
    }
}
