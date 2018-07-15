//
//  ViewController.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import UIKit

class TestAppViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    static var viewControllersCount = 1
    static let reuseIdentifier = "testAppCell"
    
    @IBOutlet var itemsTableView: UITableView!

    // MARK: View Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        guard let count = navigationController?.viewControllers.count, count < TestAppViewController.viewControllersCount else {
            return
        }

        YandexDataSource.shared.goBack()
        TestAppViewController.viewControllersCount -= 1
        itemsTableView.reloadData()
    }
    
    private func downloadDataForTable()
    {
        itemsTableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        FileDownloader.downloadYandexJson(onSuccess: {
            DispatchQueue.main.sync {
            self.itemsTableView.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            YandexDataSource.shared.updateFromDB()
            self.itemsTableView.reloadData()
            }
        }, onError: {
            DispatchQueue.main.sync {
            self.itemsTableView.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: TestAppViewController.reuseIdentifier)
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = YandexDataSource.shared
        
        if YandexDataSource.shared.allItems == []
        {
           downloadDataForTable()
        }


        let b = UIButton(type: .infoLight)
        b.titleLabel?.text = "Hello"
        var f = itemsTableView.frame.size
        f.height = 50
        let v = UITextView(frame: CGRect(x: 0, y: 0, width: f.width, height: f.height))
        v.text = "Hello"

        itemsTableView.tableHeaderView = (v)

        NotificationCenter.default.addObserver(forName: Notification.Name.DataChanged, object: nil, queue: nil) {
            (_) in
            DispatchQueue.main.sync {
                self.itemsTableView.reloadData()
            }

        }
        self.itemsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueid", sender: self)
        YandexDataSource.shared.itemSelectedAt(index: indexPath.row)
        TestAppViewController.viewControllersCount += 1
        
    }
}

