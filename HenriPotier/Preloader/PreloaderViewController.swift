//
//  PreloaderViewController.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 06/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit

class PreloaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let provider = NetworkConfig(isTesting: false).libraryProvider
        let bookRepo = BooksListRepository(with: provider)
        let offersRepo = OffersListRepository(with: provider)
        let vm = BooksListViewModel(with: bookRepo, offersRepository: offersRepo)
        
        let rootNC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let vc = rootNC.viewControllers.first as! BooksListViewController
        vc.viewModel = vm
        
        let app = UIApplication.shared.delegate as! AppDelegate
        UIView.transition(from: self.view, to: rootNC.view, duration: 0.3, options: UIViewAnimationOptions.transitionCurlUp) { completed in
            app.window?.rootViewController = rootNC
        }
        
    }
    
    

}
