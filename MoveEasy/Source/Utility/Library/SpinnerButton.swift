//
//  CustomButton.swift
//  PlanLoaderiOS
//
//  Created by Apple on 18/12/1443 AH.
//

import Foundation
import MHLoadingButton
import UIKit

class SpinnerButton: LoadingButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.indicator = BallPulseIndicator(radius: 20, color: Constants.themeColor)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        self.isLoading = true
        self.showLoader(userInteraction: false)
    }
    
    func stopLoading() {
        self.isLoading = false
        self.hideLoader()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = Constants.buttonGreen
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.backgroundColor = Constants.buttonGreen
    }
}
