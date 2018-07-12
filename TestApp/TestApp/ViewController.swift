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
        // Create destination URL
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else
        {
            return
        }


        let destinationFileUrl = documentsUrl.appendingPathComponent("yandexTree.json")
        let fileURL            = URL(string: "https://money.yandex.ru/api/categories-list")

        let sessionConfig = URLSessionConfiguration.default
        let session       = URLSession(configuration: sessionConfig)

        let request = URLRequest(url: fileURL!)

        let task = session.downloadTask(with: request)
        {
            (tempLocalUrl, response, error) in

            if let tempLocalUrl = tempLocalUrl, error == nil
            {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }

                do
                {
                    try FileManager.default.removeItem(at: destinationFileUrl)
                    print("Successfully removed file at \(destinationFileUrl)")
                }
                catch (let removeError)
                {
                    print("Error removing a file \(destinationFileUrl) : \(removeError)")
                }
                
                do
                {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    print("Successfully copied file to \(destinationFileUrl)")
                }
                catch (let writeError)
                {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }

            }
            else
            {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "Some error occured");
            }
        }
        task.resume()


        do
        {
            let jsonString = try String(contentsOf: destinationFileUrl, encoding: .utf8)
            let a = ItemParser.parseJsonFrom(string: jsonString)
            self.items = a
            print(a)
        }
        catch
        {

        }
        
        
        
    }
    
    


}

