//
//  TimerWorker.swift
//  mammafoodie
//
//  Created by Shreeram on 23/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

class TimerWorker {
    
    var seconds: Double = 0
    var timer: Timer?
    var delegate: Interactordelegate?
    
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.seconds -= 1
        if self.seconds == 0 {
            self.timer!.invalidate()
        }
        self.delegate?.DisplayTime(Time: TimeInterval(seconds))
    }
    
    func stopTimer(){
        if self.timer != nil {
            self.timer!.invalidate()
        }
    }
    
    
}
