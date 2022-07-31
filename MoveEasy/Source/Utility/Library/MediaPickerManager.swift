
import Foundation
import UIKit
import MobileCoreServices

class MediaPickerManager : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum MediaType {
        case camera, gallery, video
    }
    
    weak var viewController: UIViewController!
    var pickerView = UIImagePickerController()
    var pickFinished: ((UIImage?, URL?) -> Void)?
    var mediaType: MediaType = .camera
    
    override init() {
        super.init()
        pickerView.delegate = self
    }
    
    func pickImage(viewController: UIViewController, mediaType: MediaType, completion: @escaping (UIImage?, URL?) -> Void) {
        self.mediaType = mediaType
        pickFinished = completion
        self.viewController = viewController
        pickerView.sourceType = mediaType == .gallery ? .photoLibrary : .camera
        if mediaType == .video {
            pickerView.mediaTypes = [kUTTypeMovie as String]
        }
        self.viewController.present(pickerView, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if mediaType == .video {
            guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                fatalError("Expected a dictionary containing a URL, but was provided the following: \(info)")
            }
            pickFinished?(nil, url)
        } else {
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            pickFinished?(image, nil)
        }
    }
    
    deinit {
        debugPrint("ImportImageScreen De-allocated")
    }
}

