//
//  CartViewController.swift
//  HenriPotier
//
//  Created by Rémi Caroff on 07/05/2017.
//  Copyright © 2017 Rémi Caroff. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import DZNEmptyDataSet

class CartViewController: UIViewController, DZNEmptyDataSetSource {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var subTotalTitleLabel: UILabel!
    @IBOutlet var subTotalLabel: UILabel!
    @IBOutlet var totalTitleLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var engageButton: UIButton!
    @IBOutlet var offerLabel: UILabel!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: BooksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "your_cart".localized
        self.engageButton.setTitle("finish_order".localized, for: .normal)
        self.engageButton.layer.cornerRadius = self.engageButton.frame.size.height/2
        self.subTotalTitleLabel.text = "sub_total".localized
        self.totalLabel.text = "total".localized
        self.tableView.emptyDataSetSource = self
        
        self.setupViewModelError()
        self.setupOutput()
        self.setupInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupInput() {
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext:{ indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .asObservable()
            .subscribe(onNext:{ indexPath in
                self.viewModel.input.bookDeleted.onNext(indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    func setupOutput() {
        let dataSource = RxTableViewSectionedReloadDataSource<CartSection>()
        dataSource.canEditRowAtIndexPath = { ds, indexPath in
            return true
        }
        
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "itemCell", for: ip) as! CartItemTableViewCell
            cell.setContentWith(book: item)
            return cell
        }
        
        self.viewModel.output.selectedBooks.asObservable()
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        self.viewModel.output.getSubTotalPrice()
            .subscribe(onNext: { (_, priceFormatted) in
                self.subTotalLabel.text = priceFormatted
            })
        .disposed(by: disposeBag)
        
        self.viewModel.output.getBestPrice()
            .subscribe(onNext: { (_, priceFormatted) in
                self.totalLabel.text = priceFormatted
            }, onError: { error in
                print("error getting best price : \(error.localizedDescription)")
            })
        .disposed(by: disposeBag)
        
    }
    
    func setupViewModelError() {
        self.viewModel.viewModelError.asObservable()
            .subscribe(onNext: { apiError in
                let alert = UIAlertController(title: "error".localized, message: apiError.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            })
        .disposed(by: disposeBag)
    }
    
    @IBAction func finishButtonTapped() {
        let alert = UIAlertController(title: nil, message: "hire_message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
            Registry.instance.setDisaprovedMode(enabled: false)
            self.viewModel.selectedBooks.value = [CartSection()]
            self.performSegue(withIdentifier: "showEnd", sender: nil)
            self.viewModel.input.refresh.onNext(true)
        }))
        alert.addAction(UIAlertAction(title: "no".localized, style: .default, handler: { action in
            Registry.instance.setDisaprovedMode(enabled: true)
            self.viewModel.selectedBooks.value = [CartSection()]
            self.navigationController?.popViewController(animated: true)
            self.viewModel.input.refresh.onNext(true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "empty_basket_placeholder".localized)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableViewHeightConstraint.constant = (self.tableView.contentSize.height >= 90)
            ? self.tableView.contentSize.height
            : 90
    }
}

