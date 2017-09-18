import UIKit

protocol DishDetailRouterInput {

}

class DishDetailRouter: DishDetailRouterInput {

    weak var viewController: DishDetailViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "seguePresentSlotSelectionViewController" {
            if let destination = segue.destination as? SlotSelectionViewController,
                let source = segue.source as? DishDetailViewController {
                destination.dish = source.dishForView!.dish
                destination.selectionClosure = { (count) in
                    if count > 0 {
                        source.purchase(slots: count)
                    }
                    print("Slots to be purchased: \(count)")
                }
            }
        } else if segue.identifier == "segueShowPaymentViewController" {
            if let navController = segue.destination as? UINavigationController {
                if let destination = navController.viewControllers.first as? PaymentViewController,
                    let source = segue.source as? DishDetailViewController {
                    if let slots = sender as? UInt {
                        destination.slotsToBePurchased = slots
                        destination.dish = source.dishForView!.dish
                    }
                }
            }
        } else if segue.identifier == "segueShowConversationDetail" {
            if let destination = segue.destination as? ChatViewController {
                destination.conversation = sender as? MFConversation
            }
        }
    }
}
