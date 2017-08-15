//
//  SavedCardsVC.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 26/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Stripe
import MBProgressHUD

class SavedCardsVC: UIViewController {
    
    var cards: [STPCard] = []
    var currentLoggedInUser: String = DatabaseGateway.sharedInstance.getLoggedInUser()?.id ?? "luuN75SiCHMWenXTngLlPLeW48a2"
    var toUser: String = ""
    
    var amount : Double = 0
    
    @IBOutlet weak var clnCards: UICollectionView!
    @IBOutlet weak var conTopViewAddNewCard: NSLayoutConstraint!
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conTopViewAddNewCard.constant = -130
        self.cardTextField.font = UIFont.MontserratLight(with : 14)!
        let nib: UINib = UINib(nibName: "SavedCardClnCell", bundle: nil)
        self.clnCards.register(nib, forCellWithReuseIdentifier: "SavedCardClnCell")
        self.clnCards.delegate = self
        self.clnCards.dataSource = self
        self.getSavedCards()
    }
    
    func getSavedCards() {
        StripeGateway.shared.getPaymentSources(for: self.currentLoggedInUser, completion: { cards in
            self.cards = cards
            self.clnCards.reloadData()
        })
    }
    
    class func presentSavedCards(on vc : UIViewController, amount : Double, to : String, from : String) {
        let story = UIStoryboard.init(name: "Akshit", bundle: nil)
        if let savedCards = story.instantiateViewController(withIdentifier: "SavedCardsVC") as? SavedCardsVC {
            savedCards.amount = amount
            savedCards.toUser = "Yf5bvIiNSMTxBYK6zSajlFYoXw42"
            savedCards.currentLoggedInUser = from
            savedCards.modalPresentationStyle = .overFullScreen
            savedCards.modalPresentationCapturesStatusBarAppearance = true
            savedCards.modalTransitionStyle = .crossDissolve
            vc.present(savedCards, animated: true, completion: {
                
            })
        }
    }
    
    @IBAction func btnPayTapped(_ sender: UIButton) {
        guard let cardNumber: String = self.cardTextField.cardNumber else {
            return
        }
        
        guard let cvc = self.cardTextField.cvc else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        StripeGateway.shared.addPaymentMethod(number: cardNumber, expMonth: self.cardTextField.expirationMonth, expYear: self.cardTextField.expirationYear, cvc: cvc) { (cardId, error) in
            if let error = error {
                print(error)
            } else {
                UIView.animate(withDuration: 0.27) {
                    self.conTopViewAddNewCard.constant = 0
                    self.view.layoutIfNeeded();
                }
                if let cardId = cardId {
                    StripeGateway.shared.createCharge(amount: self.amount, sourceId: cardId, fromUserId: self.currentLoggedInUser, toUserId: self.toUser, completion: { (chargeId, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("Charge created")
                        }
                        DispatchQueue.main.async {
                            hud.hide(animated: true)
                            self.dismiss(animated: true, completion: {
                                
                            })
                        }
                    })
                } else {
                    print("Empty cardId. This should not happen")
                }
            }
        }
    }
    
    @IBAction func btnAddCardTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.27) {
            if self.conTopViewAddNewCard.constant == 0 {
                self.conTopViewAddNewCard.constant = -130
            } else {
                self.conTopViewAddNewCard.constant = 0
            }
            self.view.layoutIfNeeded();
        }
    }
}


extension SavedCardsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SavedCardClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardClnCell", for: indexPath) as! SavedCardClnCell
        cell.set(card: self.cards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card: STPCard = self.cards[indexPath.item]
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        StripeGateway.shared.createCharge(amount: amount, sourceId: card.cardId!, fromUserId: self.currentLoggedInUser, toUserId: self.toUser, completion: { (chargeId, error) in
            if let error = error {
                print(error)
            } else {
                print("Charge created")
            }
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.dismiss(animated: true, completion: {
                    
                })
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width, height: width*0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
