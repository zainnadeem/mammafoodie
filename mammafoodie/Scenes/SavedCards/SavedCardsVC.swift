//
//  SavedCardsVC.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 26/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Stripe

class SavedCardsVC: UIViewController {
    
    var cards: [STPCard] = []
    let currentLoggedInUser: String = "eSd3qbFf5leM4g6j2oVej7ZeEGA3"
    let toUser: String = "oNi1R4X6KdOS5DSLXtAQa62eD553"
    
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
    
    @IBAction func btnPayTapped(_ sender: UIButton) {
        guard let cardNumber: String = self.cardTextField.cardNumber else {
            return
        }
        
        guard let cvc = self.cardTextField.cvc else {
            return
        }
        
        StripeGateway.shared.addPaymentMethod(number: cardNumber, expMonth: self.cardTextField.expirationMonth, expYear: self.cardTextField.expirationYear, cvc: cvc) { (cardId, error) in
            if let error = error {
                print(error)
            } else {
                UIView.animate(withDuration: 0.27) {
                    self.conTopViewAddNewCard.constant = 0
                    self.view.layoutIfNeeded();
                }
                if let cardId = cardId {
                    StripeGateway.shared.createCharge(amount: 1.11, sourceId: cardId, fromUserId: self.currentLoggedInUser, toUserId: self.toUser, completion: { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("Charge created")
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
        StripeGateway.shared.createCharge(amount: 1.11, sourceId: card.cardId!, fromUserId: self.currentLoggedInUser, toUserId: self.toUser, completion: { error in
            if let error = error {
                print(error)
            } else {
                print("Charge created")
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
