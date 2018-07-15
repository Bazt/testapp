//
//  ViewController.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import UIKit

class TestAppViewController: UITableViewController, UINavigationBarDelegate
{
    override func viewWillDisappear(_ animated: Bool)
    {
        guard let count = navigationController?.viewControllers.count, count < TestAppViewController.viewControllersCount else
        {
            return
        }

        YandexDataSource.shared.goBack()
        TestAppViewController.viewControllersCount -= 1
        itemsTableView.reloadData()
    }
    
    static var viewControllersCount = 1

    private let reuseIdentifier = "testAppCell"
    
    @IBOutlet var itemsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        
        let b = UIButton(type: .infoLight)
        b.titleLabel?.text = "Hello"
        var f = itemsTableView.frame.size
        f.height = 50
        let v = UITextView(frame: CGRect(x: 0, y: 0, width: f.width, height: f.height))
        v.text = "Hello"

        
        itemsTableView.tableHeaderView = (v)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.DataChanged, object: nil, queue: nil)
        {
            (_) in
            DispatchQueue.main.sync
                {
                    self.itemsTableView.reloadData()
            }
            
        }
        self.itemsTableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("numberOfRowsInSection = \(YandexDataSource.shared.currentItems.count)")
        return YandexDataSource.shared.currentItems.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "segueid", sender: self)
        YandexDataSource.shared.itemSelectedAt(index: indexPath.row)
        TestAppViewController.viewControllersCount += 1
 
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for:indexPath) as UITableViewCell
        let itemsToShow = YandexDataSource.shared.currentItems
        cell.textLabel?.text = itemsToShow[indexPath.row].title
        if let count = itemsToShow[indexPath.row].subs?.count, count > 0
        {
            cell.accessoryType = .disclosureIndicator
        }
        else
        {
            cell.accessoryType = .none
            cell.isUserInteractionEnabled = false
        }
        print("cellForRowAt \(indexPath.row), title = \(cell.textLabel?.text ?? "nil")")
        return cell
    
    }

    override func viewWillAppear(_ animated: Bool)
    {
        //_ = FileDownloader.downloadYandexJson()
    }
}

