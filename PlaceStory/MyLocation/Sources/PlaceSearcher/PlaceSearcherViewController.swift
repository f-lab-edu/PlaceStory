//
//  PlaceSearcherViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/26/23.
//

import ModernRIBs
import UIKit

protocol PlaceSearcherPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PlaceSearcherViewController: UIViewController, PlaceSearcherPresentable, PlaceSearcherViewControllable {

    weak var listener: PlaceSearcherPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
