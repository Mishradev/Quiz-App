//
//  MainVC.swift
//  Knowledge Master Quiz
//
//  Created by Nitish Mishra on 5/20/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//

import UIKit

class MainVC: CustomTransitionViewController, ATTransitionButtonDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    setupButtons()
  }
  
  private func setupButtons() {
    
    let smallY = view.frame.minY + 280
    let width = (view.frame.width * 0.7)
    let smallX = view.frame.midX - ( width / 2 )
    
    let extendedFrame = CGRect(x: view.frame.minX + 10, y: smallY - 270, width: view.frame.width - 20, height: view.frame.height - 200)
    
    let newGameBtn = createTransitionButton(frame: CGRect(x: smallX, y: smallY, width: width, height: 70),
                                            title: "New Quiz")
    
    let leaderboardView: LeaderboardView = .fromNib()
    leaderboardView.fetchLeaderboard()
    let leaderboardBtn = createExpandableButton(frame: CGRect(x: smallX, y: smallY + 120, width: width, height: 70),
                                                expandedFrame: extendedFrame,
                                                innerView: leaderboardView,
                                                title: "Leaderboard")
    
    view.addSubview(newGameBtn)
    view.addSubview(leaderboardBtn)
  }
  
  private func createExpandableButton(frame: CGRect, expandedFrame: CGRect, innerView: UIView, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, expandedFrame: expandedFrame, innerView: innerView, title: title)
    newButton.iconTint = #colorLiteral(red: 0.6869154572, green: 0.8195564747, blue: 0.8665012717, alpha: 1)
    newButton.titleColor = #colorLiteral(red: 0.6869154572, green: 0.8195564747, blue: 0.8665012717, alpha: 1)
    newButton.backGroundColor = #colorLiteral(red: 0.04904369265, green: 0.1762623787, blue: 0.2822244465, alpha: 1)
    return newButton
  }
  
  private func createTransitionButton(frame: CGRect, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, title: title)
    newButton.iconTint = #colorLiteral(red: 0.6869154572, green: 0.8195564747, blue: 0.8665012717, alpha: 1)
    newButton.titleColor = #colorLiteral(red: 0.6869154572, green: 0.8195564747, blue: 0.8665012717, alpha: 1)
    newButton.backGroundColor = #colorLiteral(red: 0.04904369265, green: 0.1762623787, blue: 0.2822244465, alpha: 1)
    newButton.delegate = self
    return newButton
  }
  
  func didEndTransitionAnimation(_ button: ATExpandableButton) {
    performSegue(withIdentifier: "toVC2", sender: nil)
  }
    
}

