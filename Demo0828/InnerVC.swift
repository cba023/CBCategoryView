//
//  InnerVC.swift
//  Demo0828
//
//  Created by jenkins on 2020/8/28.
//  Copyright © 2020 jenkins. All rights reserved.
//

import UIKit

class InnerVC: UIViewController {
    
    var touchBeginCallback: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        touchBeginCallback = {
            print("touchesBegan")
//            self.haha()
        }
        
    }
    
    func haha() {
        print("haha")
    }
    
    deinit {
        print("🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchBeginCallback?()
    }
    
}
