//
//  ViewController.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    
    var items = [TreeItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name.Hello, object: nil, queue: nil) { (_) in
            DispatchQueue.main.sync {
                guard let xs = TestAppDatabase.getItems() else
                {
                    return
                }
                self.items = xs
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = self.items[indexPath.row].title
        if let count = self.items[indexPath.row].subs?.count, count > 0
        {
            cell?.accessoryType =  .disclosureIndicator
        }
        
        return cell!
    
    }



    override func viewWillAppear(_ animated: Bool)
    {

        guard let downloadedFileDestination = FileDownloader.downloadYandexJson() else
        {
            return
        }

        do
        {
//            let jsonString = try String(contentsOf: downloadedFileDestination, encoding: .utf8)
//            self.items = ItemParser.parseJsonFrom(string: jsonString)
            
            self.items = TestAppDatabase.getItems() ?? []
        }
        catch
        {

        }
        
        
        
        
    }
    
    


}

