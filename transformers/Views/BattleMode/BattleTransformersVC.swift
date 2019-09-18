//
//  BattleTransformersVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

class BattleTransformersVC : UIViewController {
    
    let battle = Battle()
    var battleTeams = Battle.rankedTeams
    var battleResults:[(winners: [Transformer], losers: [Transformer])]! = nil
    
    @IBOutlet weak var autobotTarget: UIView!
    @IBOutlet weak var decepticonTarget: UIView!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        battleResults = battle.battleResults()
        
        closeButton.layer.cornerRadius = closeButton.bounds.size.width / 2
        closeButton.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
        DispatchQueue.global(qos: .background).async {
            self.simulate()
        }
    }
    
    func simulate() {
        for eachResult in battleResults {
            
        }
    }
    
    
    @objc func close(_ sender: UIButton) {
        self.dismiss(animated: true) {
            // clear data?
        }
    }
}
