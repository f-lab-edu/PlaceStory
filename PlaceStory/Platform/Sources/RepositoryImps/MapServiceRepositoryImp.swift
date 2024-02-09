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
    private let searchCompleter: MKLocalSearchCompleter
    private let searchResultsSubject = CurrentValueSubject<[PlaceSearchResult], Never>([])
    private var searchResults = [MKLocalSearchCompletion]()
    private var localSearchSubject = PassthroughSubject<PlaceMark, Never>()
    
    public override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        super.init()
        
        configureSearchCompleter()
    }
    
    private func configureSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
    }
    
    private func setSearchResultsData(with searchCompletions: [MKLocalSearchCompletion]) {
        var placeSearchResults = [PlaceSearchResult]()
        for searchCompletion in searchCompletions {
            let placeSearchResult = PlaceSearchResult(
                title: searchCompletion.title,
                titleHighlightRanges: searchCompletion.titleHighlightRanges,
                subtitle: searchCompletion.subtitle,
                subtitleHighlightRanges: searchCompletion.subtitleHighlightRanges
            )
            placeSearchResults.append(placeSearchResult)
        }
        searchResultsSubject.send(placeSearchResults)
        
        searchResults = searchCompletions
    }
    
    private func performLocalSearch(with completion: MKLocalSearchCompletion) -> AnyPublisher<PlaceMark, Never> {
        let searchReqeust = MKLocalSearch.Request(completion: completion)
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
            let locationTitle = completion.title
            
            let placeRecord = PlaceMark(latitude: latitude, longitude: longitude, placeName: locationTitle, placeDescription: placeMark.debugDescription)
            
            localSearchSubject.send(placeRecord)
        }
        
        return localSearchSubject.eraseToAnyPublisher()
    }
}

// MARK: - MapServiceRepository

extension MapServiceRepositoryImp: MapServiceRepository {
    public func searchPlace(from text: String) -> AnyPublisher<[PlaceSearchResult], Never> {
        searchCompleter.queryFragment = text
        return searchResultsSubject.eraseToAnyPublisher()
    }
    
    public func startSearchWithLocalSearchCompletion(at index: Int) -> AnyPublisher<PlaceMark, Never> {
        let result = searchResults[index]
        
        return performLocalSearch(with: result)
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension MapServiceRepositoryImp: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        Log.info("results = \(results)", "[\(#file)-\(#function) - \(#line)]")
        
        setSearchResultsData(with: results)
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        Log.error("error is \(error.localizedDescription)", "[\(#file)-\(#function) - \(#line)]")
    }
}
