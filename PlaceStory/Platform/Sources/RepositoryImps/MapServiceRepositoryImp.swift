//
//  File.swift
//  
//
//  Created by 최제환 on 1/9/24.
//

import Combine
import Foundation
import MapKit
import Repositories
import Utils

public final class MapServiceRepositoryImp: NSObject {
    
    private var searchCompleter: MKLocalSearchCompleter
    private var searchResultsSubject = CurrentValueSubject<[MKLocalSearchCompletion], Never>([])
    private var localSearchSubject = PassthroughSubject<(CLLocation, String), Never>()
    
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
    public func searchPlace(from text: String) -> AnyPublisher<[MKLocalSearchCompletion], Never> {
        searchCompleter.queryFragment = text
        return searchResultsSubject.eraseToAnyPublisher()
    }
    
    public func startSearchWithLocalSearchCompletion(at index: Int) -> AnyPublisher<(CLLocation, String), Never> {
        let result = searchResultsSubject.value[index]
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
            let coordinate = CLLocation(latitude: latitude, longitude: longitude)
            let locationTitle = result.title
            
            localSearchSubject.send((coordinate, locationTitle))
        }
        
        return localSearchSubject.eraseToAnyPublisher()
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension MapServiceRepositoryImp: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResultsSubject.send(completer.results)
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        Log.error("error is \(error.localizedDescription)", "[\(#file)-\(#function) - \(#line)]")
    }
}
