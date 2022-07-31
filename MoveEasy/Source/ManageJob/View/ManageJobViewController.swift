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
    @IBOutlet var addCommentButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaPickerManager = MediaPickerManager()
        loadViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        stopWatch = nil
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
//        takeImageButton.border(color: Constants.themeColor, width: 1.0)
//        recordVideoButton.border(color: Constants.themeColor, width: 1.0)
        takeImageView.border(color: Constants.themeColor, width: 1.0)
        takeVideoView.border(color: Constants.themeColor, width: 1.0)
        addCommentButton.border(color: Constants.themeColor, width: 1.0)
        mediaButtonView.isHidden = false
        additionalInfoView.isHidden = true
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func startJobTapped(_ sender: UIButton) {
        jobStatus = .start
        let alertViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewController.statusType = .start
        alertViewController.completion = { [weak self] isYes in
            if isYes {
                self?.startTimer()
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
            }
        }
        present(alertViewController, animated: true, completion: nil)
        stopWatch?.pause()
    }
    
    @IBAction func forgotTimerTapped(_ sender: UIButton) {
        let forgotViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ForgotMovingViewController") as! ForgotMovingViewController
        navigationController?.pushViewController(forgotViewController, animated: true)
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        let receiptViewController = UIStoryboard(name: "Job", bundle: nil).instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        navigationController?.pushViewController(receiptViewController, animated: true)
    }
    
    @IBAction func viewRouteTapped(_ sender: UIButton) {
    }
    
    @IBAction func takeImageTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .camera) { [weak self] (image, url) in
        }
    }
    
    @IBAction func recordVideoTapped(_ sender: UIButton) {
        mediaPickerManager.pickImage(viewController: self, mediaType: .video) { [weak self] (image, url) in
        }
    }
    
    @IBAction func addCommentButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        additionalInfoView.isHidden = false
    }
}

