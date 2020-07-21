//
//  PopUpViewController.swift
//  ITS1
//
//  Created by admin on 7/19/20.
//  Copyright © 2020 Nixon. All rights reserved.
//

import UIKit



class PopUpViewController: UIViewController {
//
    var dataToSort : [InputData] = []
    weak var delegate: PopUpViewDelegate?
    
    @IBAction func increaseButton(_ sender: Any) {

        delegate?.incresingData()

    }
    
    @IBAction func dencreaseButton(_ sender: Any) {

        delegate?.decresingData()

    }
    @IBAction func maleButton(_ sender: Any) {

        delegate?.sortMaleData()

    }
    @IBAction func femaleButton(_ sender: Any) {

        delegate?.sortFemaleData()

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
         preferredContentSize = CGSize(width: 250, height: 250)
    }
}
