//
//  ViewController.swift
//  LogInFacebookExample
//
//  Created by Ha Thi Hoan on 12/4/18.
//  Copyright © 2018 Ha Thi Hoan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton.init()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }


}

