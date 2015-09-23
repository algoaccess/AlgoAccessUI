//
//  ViewController.swift
//  AlgoAccessUI
//
//  Created by perwyl on 23/9/15.
//  Copyright (c) 2015 algoaccess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var thisTextView: AATextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        thisTextView.setPlaceholderText("Text view placeholder")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

