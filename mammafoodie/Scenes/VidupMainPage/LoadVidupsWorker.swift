import UIKit

class LoadVidupsWorker {

    func callAPI(completion: ([Vidup]) -> Void){
        print("Place firebase logic for obtaining vidups")
        
        let video1 = Vidup(name: "1")
        let video2 = Vidup(name: "2")
        let video3 = Vidup(name: "3")
        let video4 = Vidup(name: "4")
        let video5 = Vidup(name: "5")
        let video6 = Vidup(name: "6")
        let video7 = Vidup(name: "7")
        let video8 = Vidup(name: "8")
        let video9 = Vidup(name: "9")
        let video10 = Vidup(name: "10")

        let video11 = Vidup(name: "11")

        let video12 = Vidup(name: "12")

        let video13 = Vidup(name: "13")

        let video14 = Vidup(name: "14")

        
        completion([video1, video2, video3, video4, video5, video6, video7, video8, video9, video10, video11, video12, video13, video14])
    }

}
