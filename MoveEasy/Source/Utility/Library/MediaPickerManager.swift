
import Foundation
import UIKit
import MobileCoreServices

class MediaPickerManager : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum MediaType {
        case camera, gallery, video
    }
    
    weak var viewController: UIViewController!
    var pickerView = UIImagePickerController()
    var pickFinished: ((UIImage?, URL?, String?) -> Void)?
    var mediaType: MediaType = .camera
    
    override init() {
        super.init()
        pickerView.delegate = self
    }
    
    func pickImage(viewController: UIViewController, mediaType: MediaType, completion: @escaping (UIImage?, URL?, String?) -> Void) {
        self.mediaType = mediaType
        pickFinished = completion
        
        if mediaType == .camera && !UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickFinished?(nil, nil, "Camera not available")
            return
        }
        
        self.viewController = viewController
        pickerView.sourceType = mediaType == .gallery ? .photoLibrary : .camera
        if mediaType == .video {
            pickerView.mediaTypes = [kUTTypeMovie as String, ]
        } else if mediaType == .gallery {
            pickerView.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        }
        self.viewController.present(pickerView, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if mediaType == .video {
            guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                fatalError("Expected a dictionary containing a URL, but was provided the following: \(info)")
            }
            pickFinished?(nil, url, nil)
        } else if mediaType == .gallery {
//            guard let image = info[.originalImage] as? UIImage else {
//                return
////                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//            }
//            guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
//                return
////                fatalError("Expected a dictionary containing a URL, but was provided the following: \(info)")
//            }
            
            if let image = info[.originalImage] as? UIImage {
                pickFinished?(image, nil, nil)
                return
            }
            
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                pickFinished?(nil, url, nil)
                return
            }
            pickFinished?(nil, nil, "Media error")
            
        } else {
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            pickFinished?(image, nil, nil)
        }
    }
    
    deinit {
        debugPrint("ImportImageScreen De-allocated")
    }
}

