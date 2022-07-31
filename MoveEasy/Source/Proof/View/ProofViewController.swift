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
    
    var proofViewModel: ProofViewModel? = nil
    
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
    }
    
    @IBAction func takeImageTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .camera) { [weak self] (image, url) in
//            print(image)
        }
    }
    
    @IBAction func takeVideoTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .video) { [weak self] (image, url) in
//            print("URL : ", url?.absoluteString)
        }
    }
    
    @IBAction func addCommentTapped(_ sender: UIButton) {
        addCommentButton.isHidden = true
        additionalTextView.isHidden = false
    }
    
    @IBAction func continueTTapped(_ sender: SpinnerButton) {
        let jobViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ManageJobViewController") as! ManageJobViewController
        self.navigationController?.pushViewController(jobViewController, animated: true)
        
        return
        
        if noteTextView.text == "" || noteTextView.text.isEmpty {
            return
        }
        
        proofViewModel?.saveNotes(bookingID: 1310, notes: noteTextView.text, completion: { success, error in
            DispatchQueue.main.async {
                if success {
                    let jobViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ManageJobViewController") as! ManageJobViewController
                    self.navigationController?.pushViewController(jobViewController, animated: true)
                } else {
                    self.showAlert(title: "Notes", message: error ?? "Error occured while saving notes")
                }
            }
        })
    }
}
