//
//  ManageJobViewController.swift
//  MoveEasy
//
//  Created by Apple on 11/12/1443 AH.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import FittedSheets

class ManageJobViewController: UIViewController {
    
    enum JobStatus {
        case start
        case pause
        case stop
        case back
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
    @IBOutlet weak var attachmentNoteLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var milliSecLabel: UILabel!
    @IBOutlet weak var timerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var forgotStartTimeLabel: UIButton!
    @IBOutlet weak var timerTop: NSLayoutConstraint!
    @IBOutlet weak var jobButtonViewTop: NSLayoutConstraint!
    @IBOutlet weak var forgotTimerLabelTop: NSLayoutConstraint!
    @IBOutlet weak var attachmentTimerLabelTop: NSLayoutConstraint!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    
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
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var stopWatch: StopWatch? = StopWatch()
    var timer: Timer? = Timer()
    var everyMinuteTimer: Timer? = Timer()
    var mediaPickerManager: MediaPickerManager!
    var manageJobViewModel: ManageJobViewModel!
    var proofViewModel: ProofViewModel!
    var timerPaused: Bool = false
    
    lazy var fileUploader: FileUploader? = FileUploader()
    
    var source: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var destination: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        mediaPickerManager = MediaPickerManager()
        loadViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        everyMinuteTimer?.invalidate()
        everyMinuteTimer = nil
        timer = nil
        stopWatch = nil
    }
    
    func configure() {
        manageJobViewModel = ManageJobViewModel()
        proofViewModel = ProofViewModel()
        
        if manageJobViewModel.stops?.count ?? 0 > 2 {
            continueButton.setTitle("Next pickup")
        } else {
            continueButton.setTitle("Navigate to drop off")
        }
        
        source = CLLocationCoordinate2D(latitude: Double(manageJobViewModel.stops?[0].lat ?? "0.0") ?? 0.0, longitude: Double(manageJobViewModel.stops?[0].long ?? "0.0") ?? 0.0)
        destination = CLLocationCoordinate2D(latitude: Double(manageJobViewModel.stops?[1].lat ?? "0.0") ?? 0.0, longitude: Double(manageJobViewModel.stops?[1].long ?? "0.0") ?? 0.0)
        getUpdatedTime()
    }
    
    func getUpdatedTime() {
        manageJobViewModel.getUpdateBookingTime { error in
            if let error = error {
                self.showAlert(title: "Error", message: error)
                return
            }
            self.stopWatch?.start(from: self.manageJobViewModel.pausedTime)
            self.timerLabel.text = self.stopWatch?.inString
        }
    }
    
    func hideTimerView() {
        workTimeLabel.isHidden = true
        timerViewHeight.constant = 0
        startView.isHidden = true
        pauseView.isHidden = true
        stopView.isHidden = true
        forgotStartTimeLabel.isHidden = true
//        attachmentNoteLabel.isHidden = true
//        mediaButtonView.isHidden = true
        continueButton.isHidden = false
        timerTop.constant = 0
        jobButtonViewTop.constant = 0
        forgotTimerLabelTop.constant = 0
        attachmentTimerLabelTop.constant = 0
    }
    
    func startTimer() {
        if timerPaused {
            stopWatch?.start(from: 0.0)
            timerPaused = false
        } else {
            stopWatch?.start(from: self.manageJobViewModel.pausedTime)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
//            print(self.stopWatch?.elapsedTime)
            self.timerLabel.text = self.stopWatch?.inString
//            let timeArr = self.stopWatch?.inString.components(separatedBy: ":")
//            self.minuteLabel.text = timeArr?[0] // self.stopWatch?.inSeparateString.0
//            self.secondLabel.text = timeArr?[1] // self.stopWatch?.inSeparateString.1
//            self.milliSecLabel.text = timeArr?[2]
//            DispatchQueue.main.async {
//                self.minuteLabel.text =  self.stopWatch?.inSeparateString.0
//                self.secondLabel.text = self.stopWatch?.inSeparateString.1
//                self.milliSecLabel.text = self.stopWatch?.inSeparateString.2
//            }
            
//            print("\(self.stopWatch?.inSeparateString.0 ?? "") \(self.stopWatch?.inSeparateString.1 ?? "") \(self.stopWatch?.inSeparateString.2 ?? "")")
        }
    }
    
    func stopTimer() {
        stopWatch?.pause()
        everyMinuteTimer?.invalidate()
        timer?.invalidate()
        timer = nil
        everyMinuteTimer = nil
    }
    
    func loadViews() {
        activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: .ballRotateChase, color: .black, padding: 170)
        self.view.addSubview(activityIndicatorView)
        
        startView.round(radius: 15)
        pauseView.round(radius: 15)
        stopView.round(radius: 15)
        forgotStartTimeLabel.underline()
        viewRouteButton.round()
        continueButton.round()
        takeImageView.border(color: Constants.themeColor, width: 1.0)
        takeVideoView.border(color: Constants.themeColor, width: 1.0)
        addCommentButton.border(color: Constants.themeColor, width: 1.0)
        mediaButtonView.isHidden = false
        additionalInfoView.isHidden = true
        imageActivityIndicator.isHidden = true
        videoActivityIndicator.isHidden = true
        addressLabel.text = "Pickup: \(OrderSession.shared.bookingModel?.pickupLocation ?? "")"
        switchView.isOn = Defaults.driverStatus ?? true
        continueButton.isHidden = true
        viewRouteButton.isHidden = true
        typeLabel.text = OrderSession.shared.bookingModel?.type
        
        if (OrderSession.shared.bookingModel?.type?.lowercased() == "Delivery".lowercased()) {
            hideTimerView()
        }
    }
    
    func startMoving() {
        manageJobViewModel.startMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)")
    }
    
    func pauseMoving() {
        manageJobViewModel.pauseMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)")
    }
    
    func endMovingTimer() {
        manageJobViewModel.endMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)"){ [weak self] error in
//            if let error = error {
//                self?.showAlert(title: "Error", message: error)
//                return
//            }
            self?.navigateToNextScreen()
        }
    }
    
//    func stopMoving() {
//        manageJobViewModel.stopMoving(bookingID: "\(OrderSession.shared.bookingModel?.id ?? 0)") { [weak self] error in
//            if let error = error {
//                self?.showAlert(title: "Error", message: error)
//                return
//            }
//            self?.navigateToNextScreen()
//        }
//    }
    
    func showStopAlert() {
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .stopped
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.stopTimer()
                self?.mediaButtonView.isHidden = false
                self?.additionalInfoView.isHidden = false
                //                self?.backButton.isHidden = false
//                self?.stopMoving()
                self?.endMovingTimer()
            }
        }
        present(alertViewController, animated: true, completion: nil)
        stopWatch?.pause()
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
    
    func everyMinuteCall() {
        everyMinuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    func timerLog() {
        print("timerLog()")
        manageJobViewModel.timerLog { [weak self] error in
            DispatchQueue.main.async {
                
                if let error = error {
                    self?.showAlert(title: "Error", message: error)
                    return
                }
            }
        }
    }
    
    func updateTimer() {
        manageJobViewModel.updateBookingTimer(seconds: Int(stopWatch?.elapsedTime ?? 0.0))
    }
    
    private func navigateToNextScreen() {
//        OrderSession.shared.bookingModel?.isDeliverNow == true && OrderSession.shared.bookingModel?.type?.lowercased() == "Delivery".lowercased()
        if OrderSession.shared.bookingModel?.type?.lowercased() == "Delivery".lowercased() {
            let feedBackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
            feedBackViewController.feedbackViewModel = FeedbackViewModel()
            let sheetController = SheetViewController(controller: feedBackViewController, sizes:[.marginFromTop(150.0)], options: Constants.fittedSheetOptions)
            sheetController.cornerRadius = 0
            feedBackViewController.onDismiss = { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            self.present(sheetController, animated: true, completion: nil)
            return
        }
        OrderSession.shared.bookingModel?.completionTime = stopWatch?.elapsedTime
        let receiptViewController = Constants.kJob.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        receiptViewController.receiptViewModel = ReceiptViewModel(receiptModel: manageJobViewModel.receipt)
        navigationController?.pushViewController(receiptViewController, animated: true)
        
    }
    
    func startNavigation() {
        let pickupLat = Double(OrderSession.shared.bookingModel?.pickupLatitude ?? "0.0")
        let pickupLng = Double(OrderSession.shared.bookingModel?.pickupLongitude ?? "0.0")
        let pickupLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: pickupLat ?? 0.0, longitude: pickupLng ?? 0.0)
        
        let dropoffLat = Double(OrderSession.shared.bookingModel?.dropofflatitude ?? "0.0")
        let dropoffLng = Double(OrderSession.shared.bookingModel?.dropoffLongitude ?? "0.0")
        let dropoffLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: dropoffLat ?? 0.0, longitude: dropoffLng ?? 0.0)
        
        if let pickupLocation = pickupLocation, let dropoffLocation = dropoffLocation {
            let appleMap = AppleMap(source: pickupLocation, destination: dropoffLocation)
            appleMap.present(in: self, sourceView: UIView())
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if jobStatus != nil {
            jobStatus = .back
            let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            alertViewController.statusType = .back
            alertViewController.completion = { [weak self] isYes in
                if isYes {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            present(alertViewController, animated: true, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startJobTapped(_ sender: UIButton) {
        jobStatus = .start
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .start
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.startTimer()
                self?.everyMinuteCall()
                self?.continueButton.isHidden = false
                self?.viewRouteButton.isHidden = false
                self?.startMoving()
            }
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func pauseJobTapped(_ sender: UIButton) {
        jobStatus = .pause
        timerPaused = true
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .paused
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.stopTimer()
//                self?.stopMoving()
                self?.pauseMoving()
            }
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func stopJobTapped(_ sender: UIButton) {
        jobStatus = .stop
        showStopAlert()
//        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
//        alertViewController.statusType = .stopped
//        alertViewController.completion = { [weak self] isYes in
//            if isYes {
//                self?.stopTimer()
//                self?.mediaButtonView.isHidden = false
//                self?.additionalInfoView.isHidden = false
//                //                self?.backButton.isHidden = false
////                self?.stopMoving()
//                self?.endMovingTimer()
//            }
//        }
//        present(alertViewController, animated: true, completion: nil)
//        stopWatch?.pause()
    }
    
    @IBAction func forgotTimerTapped(_ sender: UIButton) {
        
        let receiptViewController = Constants.kJob.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        receiptViewController.viewType = .forgotTimer
//        receiptViewController.receiptViewModel = ReceiptViewModel(receiptModel: manageJobViewModel.receipt)
        navigationController?.pushViewController(receiptViewController, animated: true)
        
//        let forgotViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ForgotMovingViewController") as! ForgotMovingViewController
//        forgotViewController.forgotMovingViewModel = ForgotMovingViewModel()
//        navigationController?.pushViewController(forgotViewController, animated: true)
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        if commentTextView.text != "" || !commentTextView.text.isEmpty {
            saveNotes()
            return
        }
        
//        if continueButton.currentTitle?.contains("Navigate") == true {
//            startNavigation()
//            continueButton.setTitle("Complete job", for: .normal)
//        } else {
//        }
//        return
        
        // Below code is of added stops
        manageJobViewModel.stopCounter += 1
        
        if manageJobViewModel.isLastDestination {
            showStopAlert()
//            stopMoving()
        }
        
        var buttonTitle: String = "Complete job"
        
        if (manageJobViewModel.stops?.count ?? 0) - 1 == manageJobViewModel.stopCounter {
            
            let sourceLat = Double(manageJobViewModel.stops?[(manageJobViewModel.stops?.count ?? 0) - 2].lat ?? "0.0")
            let sourceLng = Double(manageJobViewModel.stops?[(manageJobViewModel.stops?.count ?? 0) - 2].long ?? "0.0")
            source = CLLocationCoordinate2D(latitude: sourceLat ?? 0.0, longitude: sourceLng ?? 0.0)
//
            let destLat = Double(manageJobViewModel.stops?[(manageJobViewModel.stops?.count ?? 0) - 1].lat ?? "0.0")
            let destLng = Double(manageJobViewModel.stops?[(manageJobViewModel.stops?.count ?? 0) - 1].long ?? "0.0")
            destination = CLLocationCoordinate2D(latitude: destLat ?? 0.0, longitude: destLng ?? 0.0)
//
            let appleMap = AppleMap(source: source, destination: destination)
            appleMap.present(in: self, sourceView: backButton)
            
            addressLabel.text = "Drop off: \(OrderSession.shared.bookingModel?.dropoffLocation ?? "")"
//            continueButton.setTitle("Complete job")
            buttonTitle = "Complete job"
            manageJobViewModel.isLastDestination = true
        } else {
            buttonTitle = "Next pickup"
            if manageJobViewModel.stopCounter < manageJobViewModel.stops?.count ?? 0 {
                addressLabel.text = "Pickup: \(manageJobViewModel.stops?[manageJobViewModel.stopCounter].stop ?? "")"
                
                let sourceLat = Double(manageJobViewModel.stops?[manageJobViewModel.stopCounter - 1].lat ?? "0.0")
                let sourceLng = Double(manageJobViewModel.stops?[manageJobViewModel.stopCounter - 1].long ?? "0.0")
                source = CLLocationCoordinate2D(latitude: sourceLat ?? 0.0, longitude: sourceLng ?? 0.0)
//
                let destLat = Double(manageJobViewModel.stops?[manageJobViewModel.stopCounter].lat ?? "0.0")
                let destLng = Double(manageJobViewModel.stops?[manageJobViewModel.stopCounter].long ?? "0.0")
                destination = CLLocationCoordinate2D(latitude: destLat ?? 0.0, longitude: destLng ?? 0.0)
//
                let appleMap = AppleMap(source: source, destination: destination)
                appleMap.present(in: self, sourceView: backButton)
                
                if (manageJobViewModel.stops?.count ?? 0) - 2 == manageJobViewModel.stopCounter {
                    buttonTitle = "Navigate to drop off"
                }
            }
        }
        continueButton.setTitle(buttonTitle)
    }
    
    @IBAction func viewRouteTapped(_ sender: UIButton) {
        print("route : ", source, destination)
        let appleMap = AppleMap(source: source, destination: destination)
        appleMap.present(in: self, sourceView: backButton)
    }
    
    @IBAction func changeDriverStatus(_ sender: UISwitch) {
        DriverSession.shared.setDriverStatus(status: sender.isOn ? false : true)
    }
    
    @IBAction func takeImageTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .camera) { [weak self] (image, url, error)  in
            if error != nil {
                self?.showAlert(title: "Media Error", message: error ?? "Something went wrong with Camera")
                return
            }
            
            self?.uploadMedia(data: (image?.pngData())!, mediaType: .gallery)
        }
    }
    
    @IBAction func recordVideoTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .video) { [weak self] (image, url, error) in
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

