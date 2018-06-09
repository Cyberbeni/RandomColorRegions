//
//  DrawingViewController.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 08..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import UIKit

class DrawingViewController: BaseViewController<DrawingView> {
    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self.baseView,
            action: #selector(DrawingView.reset)
        )
    }
}

