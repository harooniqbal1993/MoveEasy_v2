//
//  ManageJobViewController.swift
//  MoveEasy
//
//  Created by Apple on 11/12/1443 AH.
//

import UIKit

class ManageJobViewController: UIViewController {
    
    enum JobStatus {
        case start
        case pause
        case stop
    }
    
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var viewRouteButton: UIButton!
    @IBOutlet weak var startJobLabel: UILabel!
    @IBOutlet weak var pauseJobLabel: UILabel!
    @IBOutlet weak var stopJobLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mediaButtonView: UIView!
    @IBOutlet weak var additionalInfoView: UIView!
    @IBOutlet weak var takeImageButton: UIButton!
    @IBOutlet weak var recordVideoButton: UIButton!
    @IBOutlet weak var addtionalInfoTextView: UIView!
    @IBOutlet weak var takeImageView: UIView!
    @IBOutlet weak var takeVideoView: UIView!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var jobStatus: JobStatus? = nil {
        didSet {
            if jobStatus == .start {
                startView.backgroundColor = Constants.themeColor
                pauseView.backgroundColor = .white
                stopView.backgroundColor = .white
                startJobLabel.textColor = .white
                pauseJobLabel.textColor = Constants.themeColor
                stopJobLabel.textColor = Constants.themeColor
            } else if jobStatus == .pause {
                startView.backgroundColor = .white
                pauseView.backgroundColor = Constants.themeColor
                stopView.backgroundColor = .white
                startJobLabel.textColor = Constants.themeColor
                pauseJobLabel.textColor = .white
                stopJobLabel.textColor = Constants.themeColor
            } else {
                startView.backgroundColor = .white
                pauseView.backgroundColor = .white
                stopView.backgroundColor = Constants.themeColor
                startJobLabel.textColor = Constants.themeColor
                pauseJobLabel.textColor = Constants.themeColor
                stopJobLabel.textColor = .white
            }
        }
    }
    
    var stopWatch: StopWatch? = StopWatch()
    var timer: Timer? = Timer()
    var mediaPickerManager: MediaPickerManager!
    var manageJobViewModel: ManageJobViewModel!
    var proofViewModel: ProofViewModel!
    
    lazy var fileUploader: FileUploader? = FileUploader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        mediaPickerManager = MediaPickerManager()
        loadViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        stopWatch = nil
    }
    
    func configure() {
        manageJobViewModel = ManageJobViewModel()
        proofViewModel = ProofViewModel()
    }
    
    func startTimer() {
        stopWatch?.start()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.timerLabel.text = self.stopWatch?.inString
        }
    }
    
    func stopTimer() {
        stopWatch?.pause()
        timer?.invalidate()
    }
    
    func loadViews() {
        startView.round(radius: 15)
        pauseView.round(radius: 15)
        stopView.round(radius: 15)
        viewRouteButton.round()
        continueButton.round()
        takeImageView.border(color: Constants.themeColor, width: 1.0)
        takeVideoView.border(color: Constants.themeColor, width: 1.0)
        addCommentButton.border(color: Constants.themeColor, width: 1.0)
        mediaButtonView.isHidden = false
        additionalInfoView.isHidden = true
        imageActivityIndicator.isHidden = true
        videoActivityIndicator.isHidden = true
        addressLabel.text = OrderSession.shared.order?.dropoffLocation
    }
    
    func startMoving() {
        manageJobViewModel.startMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)")
    }
    
    func pauseMoving() {
        manageJobViewModel.pauseMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)")
    }
    
    func stopMoving() {
        manageJobViewModel.stopMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)") { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error)
                return
            }
        }
    }
    
    private func startAnimation(mediaType: MediaPickerManager.MediaType) {
        if mediaType == .gallery {
            takeImageButton.isUserInteractionEnabled = false
            imageActivityIndicator.isHidden = false
            imageActivityIndicator.startAnimating()
        } else {
            recordVideoButton.isUserInteractionEnabled = false
            videoActivityIndicator.isHidden = false
            videoActivityIndicator.startAnimating()
        }
    }
    
    private func stopAnimation(mediaType: MediaPickerManager.MediaType) {
        if mediaType == .gallery {
            takeImageButton.isUserInteractionEnabled = true
            imageActivityIndicator.isHidden = true
            imageActivityIndicator.stopAnimating()
        } else {
            recordVideoButton.isUserInteractionEnabled = true
            videoActivityIndicator.isHidden = true
            videoActivityIndicator.stopAnimating()
        }
    }
    
    private func saveNotes() {
        proofViewModel?.saveNotes(bookingID: (OrderSession.shared.order?.id ?? 0), notes: commentTextView.text, completion: { [weak self] success, error in
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
    
    private func navigateToNextScreen() {
        let receiptViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        receiptViewController.receiptViewModel = ReceiptViewModel(receiptModel: manageJobViewModel.receipt)
        navigationController?.pushViewController(receiptViewController, animated: true)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startJobTapped(_ sender: UIButton) {
        jobStatus = .start
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .start
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.startTimer()
//                self?.startMoving()
            }
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func pauseJobTapped(_ sender: UIButton) {
        jobStatus = .pause
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .paused
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.stopTimer()
                self?.stopMoving()
            }
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func stopJobTapped(_ sender: UIButton) {
        jobStatus = .stop
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .stopped
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.stopTimer()
                self?.mediaButtonView.isHidden = false
                self?.additionalInfoView.isHidden = false
                self?.stopMoving()
            }
        }
        present(alertViewController, animated: true, completion: nil)
        stopWatch?.pause()
    }
    
    @IBAction func forgotTimerTapped(_ sender: UIButton) {
        let forgotViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ForgotMovingViewController") as! ForgotMovingViewController
        forgotViewController.forgotMovingViewModel = ForgotMovingViewModel()
        navigationController?.pushViewController(forgotViewController, animated: true)
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        if commentTextView.text != "" || !commentTextView.text.isEmpty {
            saveNotes()
            return
        }
        navigateToNextScreen()
    }
    
    @IBAction func viewRouteTapped(_ sender: UIButton) {
    }
    
    @IBAction func takeImageTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .gallery) { [weak self] (image, url, error)  in
            if error != nil {
                self?.showAlert(title: "Media Error", message: error ?? "Something went wrong with Camera")
                return
            }
            
            self?.uploadMedia(data: (image?.pngData())!, mediaType: .gallery)
        }
    }
    
    @IBAction func recordVideoTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .gallery) { [weak self] (image, url, error) in
            if error != nil {
                self?.showAlert(title: "Media Error", message: error ?? "Something went wrong with Camera")
                return
            }
            guard let url = url else { return }

            do {
                let video = try Data(contentsOf: url)
                self?.uploadMedia(data: video, mediaType: .video)
            } catch {
                print("Error : ", error)
            }
        }
    }
    
    @IBAction func addCommentButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        additionalInfoView.isHidden = false
    }
}

