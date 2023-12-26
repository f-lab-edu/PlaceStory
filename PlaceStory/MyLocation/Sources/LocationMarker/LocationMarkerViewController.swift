//
//  LocationMarkerViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs
import UIKit

protocol LocationMarkerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class LocationMarkerViewController: UIViewController, LocationMarkerPresentable, LocationMarkerViewControllable {

    weak var listener: LocationMarkerPresentableListener?
}
