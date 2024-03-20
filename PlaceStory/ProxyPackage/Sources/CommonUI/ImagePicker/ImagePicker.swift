//
//  File.swift
//  
//
//  Created by 최제환 on 3/19/24.
//

import Foundation
import PhotosUI

public protocol PhotoPickerViewControllerDelegate: AnyObject {
    func nonSelectionImage()
    func didFinishPicking(_ imageDatas: [Data])
}

// 참고) https://ios-daniel-yang.tistory.com/83#article-4--%EC%82%AC%EC%9A%A9-%EB%B0%A9%EB%B2%95---2
public final class PhotoPicker {
    public weak var delegate: PhotoPickerViewControllerDelegate?

    // Identifier와 PHPickerResult로 만든 Dictionary (이미지 데이터를 저장하기 위해 만들어 줌)
    private var selections = [String : PHPickerResult]()
    
    // 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장해줄 겁니다.
    // selections은 딕셔너리이기 때문에 순서가 없습니다. 그래서 따로 식별자를 담을 배열 생성
    private var selectedAssetIdentifiers = [String]()
    
    private var picker: PHPickerViewController
    
    public init(
        limit: Int,
        filter: PHPickerFilter
    ) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        configuration.selectionLimit = limit
        configuration.selection = .ordered
        configuration.preferredAssetRepresentationMode = .current
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
    }
    
    public func getPickerViewController() -> PHPickerViewController {
        return picker
    }
    
    private func displayImage() {
        let dispatchGroup = DispatchGroup()
        
        var imagesDict = [String: UIImage]()
        var selectedImageData = [Data]()
        
        for (identifier, result) in selections {
            dispatchGroup.enter()
            
            let itemProvider = result.itemProvider
            
            // 만약 itemProvider에서 UIImage로 로드가 가능하다면?
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                // 로드 핸들러를 통해 UIImage를 처리해 줍시다. (비동기적으로 동작)
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    guard let image = image as? UIImage else { return }
                    
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            // 선택한 이미지의 순서대로 정렬하여 append
            for (index, identifier) in self.selectedAssetIdentifiers.enumerated() {
                guard let image = imagesDict[identifier] else { return }
                guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
                selectedImageData.append(imageData)
                
                if index == self.selectedAssetIdentifiers.count - 1 {
                    self.delegate?.didFinishPicking(selectedImageData)
                }
            }
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension PhotoPicker: PHPickerViewControllerDelegate {
    public func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        var newSelections: [String: PHPickerResult] = [:]
        
        for result in results {
            let identifier = result.assetIdentifier!
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if selections.isEmpty {
            delegate?.nonSelectionImage()
        } else {
            displayImage()
        }
    }
}
