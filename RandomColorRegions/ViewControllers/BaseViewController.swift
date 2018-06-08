//
//  BaseViewController.swift
//  RandomColorRegions
//
//  Created by Benedek Kozma on 2018. 06. 08..
//  Copyright © 2018. Benedek Kozma. All rights reserved.
//

import UIKit

class BaseViewController<BaseView: UIView>: UIViewController {
    var baseView: BaseView { return self.view as! BaseView }

    // MARK: overrides
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
    
    override func loadView() {
        self.view = BaseView()
    }
}
