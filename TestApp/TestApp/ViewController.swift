//
//  ViewController.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
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
            print(a)
        }
        catch
        {

        }
        
        
        
    }
    
    


}

