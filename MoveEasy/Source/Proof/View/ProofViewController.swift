//
//  ProofViewController.swift
//  MoveEasy
//
//  Created by Apple on 10/12/1443 AH.
//

import UIKit
import AVFoundation

class ProofViewController: UIViewController {

    @IBOutlet weak var takeImageView: UIView!
    @IBOutlet weak var recordVideoView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var continueButton: SpinnerButton!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var additionalTextView: UIView!
    @IBOutlet weak var fileActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attachFileButton: UIButton!
    @IBOutlet weak var attachVideoButton: UIButton!
    
    var proofViewModel: ProofViewModel? = nil
    
    lazy var fileUploader: FileUploader? = FileUploader()
    
    let captureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.layer.cornerRadius = 100
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    var mediaPickerManager: MediaPickerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadViews()
    }
    
    func configure() {
        proofViewModel = ProofViewModel()
        mediaPickerManager = MediaPickerManager()
    }
    
    func loadViews() {
        takeImageView.border(color: Constants.themeColor, width: 1.0)
        recordVideoView.border(color: Constants.themeColor, width: 1.0)
        addCommentButton.border(color: Constants.themeColor, width: 1.0)
        continueButton.round()
        fileActivityIndicator.isHidden = true
        videoActivityIndicator.isHidden = true
    }
    
    private func startAnimation(mediaType: MediaPickerManager.MediaType) {
        if mediaType == .gallery {
            attachFileButton.isUserInteractionEnabled = false
            fileActivityIndicator.isHidden = false
            fileActivityIndicator.startAnimating()
        } else {
            attachVideoButton.isUserInteractionEnabled = false
            videoActivityIndicator.isHidden = false
            videoActivityIndicator.startAnimating()
        }
    }
    
    private func stopAnimation(mediaType: MediaPickerManager.MediaType) {
        if mediaType == .gallery {
            attachFileButton.isUserInteractionEnabled = true
            fileActivityIndicator.isHidden = true
            fileActivityIndicator.stopAnimating()
        } else {
            attachVideoButton.isUserInteractionEnabled = true
            videoActivityIndicator.isHidden = true
            videoActivityIndicator.stopAnimating()
        }
    }
    
    private func navigateToNextScreen() {
        let jobViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ManageJobViewController") as! ManageJobViewController
        self.navigationController?.pushViewController(jobViewController, animated: true)
    }
    
    private func saveNotes() {
        proofViewModel?.saveNotes(bookingID: (OrderSession.shared.order?.id ?? 0), notes: noteTextView.text, completion: { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.navigateToNextScreen()
                } else {
                    self?.showAlert(title: "Notes", message: error ?? "Error occured while saving notes")
                }
            }
        })
    }
    
    private func uploadMedia(data: Data, mediaType: MediaPickerManager.MediaType) {
        startAnimation(mediaType: mediaType)
        let media: [FileUploader.Media]? = [FileUploader.Media(withImage: data)] as? [FileUploader.Media]
        self.fileUploader?.formDataUpload(url: URL(string: "\(NetworkService.shared.baseURL)\(Constants.EndPoints.pickupFiles.rawValue)?id=\(OrderSession.shared.order?.id ?? 0)")!, media: media ?? [], resultType: String.self, completion: { [weak self] str, error in
            DispatchQueue.main.async {
                self?.stopAnimation(mediaType: mediaType)

                if let error = error {
                    self?.showAlert(title: "Error", message: error)
                    return
                }
            }
        })
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takeImageTapped(_ sender: UIButton) {
        
        mediaPickerManager.pickImage(viewController: self, mediaType: .gallery) { [weak self] (image, url, error) in
            if error != nil {
                self?.showAlert(title: "Media Error", message: error ?? "Something went wrong with Camera")
                return
            }
            self?.uploadMedia(data: (image?.pngData())!, mediaType: .gallery)
        }
    }
    
    @IBAction func takeVideoTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .gallery) { [weak self] (image, url, error) in
            if error != nil {
                self?.showAlert(title: "Media Error", message: error ?? "Something went wrong with Camera")
                return
            }
            
            self?.attachVideoButton.isUserInteractionEnabled = false
            self?.videoActivityIndicator.isHidden = false
            self?.videoActivityIndicator.startAnimating()
            
            do {
                let video = try Data(contentsOf: url!)
                self?.uploadMedia(data: video, mediaType: .video)
            } catch {
                print("Error : ", error)
            }
        }
    }
    
    @IBAction func addCommentTapped(_ sender: UIButton) {
        addCommentButton.isHidden = true
        additionalTextView.isHidden = false
    }
    
    @IBAction func continueTTapped(_ sender: SpinnerButton) {

        if noteTextView.text != "" || !noteTextView.text.isEmpty {
            saveNotes()
            return
        }
        navigateToNextScreen()
    }
}
