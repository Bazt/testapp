//
//  ViewController.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import UIKit

class TestAppViewController: UITableViewController
{
    private let reuseIdentifier = "testAppCell"
    
    @IBOutlet var itemsTableView: UITableView!
    var items = [TreeItem]()
    var itemsToShow = [TreeItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name.Hello, object: nil, queue: nil) { (_) in
            DispatchQueue.main.sync {
                guard let xs = TestAppDatabase.getItems() else
                {
                    return
                }
                self.items = xs
                self.itemsToShow = self.items
                self.itemsTableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.itemsToShow.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = indexPath.row
        if let count = self.itemsToShow[row].subs?.count, count > 0
        {
            self.itemsToShow = itemsToShow[row].subs!
            self.itemsTableView.reloadData()
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for:indexPath) as UITableViewCell
        
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
        
        return cell
    
    }

    override func viewWillAppear(_ animated: Bool)
    {
        itemsToShow = items
        _ = FileDownloader.downloadYandexJson()
    }
}

