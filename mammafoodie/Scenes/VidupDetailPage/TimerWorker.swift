//
//  TimerWorker.swift
//  mammafoodie
//
//  Created by Shreeram on 23/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class TimerWorker:NSObject {
    
    var seconds:Int = 0
    var timer:Timer?
    var delegate:Interactordelegate?
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1
        if seconds == 0 {
            timer!.invalidate()
        }
        delegate?.DisplayTime(Time: TimeInterval(seconds))
    }
    
    func stopTimer(){
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    
}
