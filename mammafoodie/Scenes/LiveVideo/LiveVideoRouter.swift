import UIKit

protocol LiveVideoRouterInput {
    
}

class LiveVideoRouter: LiveVideoRouterInput {
    
    weak var viewController: LiveVideoViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender : Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "seguePresentSlotSelectionViewController" {
            if let destination = segue.destination as? SlotSelectionViewController,
                let source = segue.source as? LiveVideoViewController {
                destination.dish = source.liveVideo
                destination.selectionClosure = { (count) in
                    if count > 0 {
                        source.purchase(slots: count)
                    }
                    print("Slots to be purchased: \(count)")
                }
            }
        } else if segue.identifier == "segueShowPaymentViewController" {
            if let destination = segue.destination as? PaymentViewController,
                let source = segue.source as? LiveVideoViewController {
                if let slots = sender as? UInt {
                    destination.slotsToBePurchased = slots
                    destination.dish = source.liveVideo
                }
            }
        }
    }
}
