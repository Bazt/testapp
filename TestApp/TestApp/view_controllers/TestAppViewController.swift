//
//  ViewController.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import UIKit

class TestAppViewController: UIViewController, UITableViewDelegate {

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

    @objc private func downloadDataForTable() {
        itemsTableView.isUserInteractionEnabled = false

        FileDownloader.downloadYandexJson(onSuccess: {
            DispatchQueue.main.sync {
                self.itemsTableView.isUserInteractionEnabled = true
                YandexDataSource.shared.updateFromDB()
                self.itemsTableView.reloadData()
            }
        }, onError: {
            DispatchQueue.main.sync {
                self.itemsTableView.isUserInteractionEnabled = true
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = itemsTableView.indexPathForSelectedRow {
            itemsTableView.deselectRow(at: indexPath, animated: false)
        }
    }


    private func addReloadButton() {
        var f = itemsTableView.frame.size
        f.height = 50
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: f.width / 3, height: f.height))
        b.backgroundColor = UIColor.lightGray

        b.setTitle("Reload from web", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)

        b.setTitleColor(UIColor.gray, for: .highlighted)
        b.setTitleColor(UIColor.lightGray, for: .focused)
        b.addTarget(self, action: #selector(downloadDataForTable), for: .touchUpInside)


        b.titleLabel?.textAlignment = NSTextAlignment.center
        itemsTableView.tableHeaderView = b
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        addReloadButton()

        self.itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: TestAppViewController.reuseIdentifier)
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = YandexDataSource.shared

        if YandexDataSource.shared.allItems == [] {
            downloadDataForTable()
        }

        self.itemsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueid", sender: self)
        YandexDataSource.shared.itemSelectedAt(index: indexPath.row)
        TestAppViewController.viewControllersCount += 1

    }
}

