//
//  EndViewController.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 08/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBAction func endButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
