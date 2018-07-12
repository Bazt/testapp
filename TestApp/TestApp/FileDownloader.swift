//
//  FileDownloader.swift
//  TestApp
//
//  Created by Oleg Shcherbakov on 12/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation


class FileDownloader
{
    class func downloadYandexJson() -> URL?
    {
        var downloadedFileUrl: URL? = nil
        
        guard let destinationFileUrl = self.destinationForYandexJson,
              let remoteFileURL = self.remoteUrlForYandexJson else
        {
            return nil
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session       = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url: remoteFileURL)
        
        let task = session.downloadTask(with: request)
        {
            (tempLocalUrl, response, error) in
            
            if let tempLocalUrl = tempLocalUrl, error == nil
            {
                
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
                    downloadedFileUrl = destinationFileUrl
                    
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

        return downloadedFileUrl
    }
    
    private static var destinationForYandexJson: URL?
    {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else
        {
            return nil
        }
        
        let destinationFileUrl = documentsUrl.appendingPathComponent("yandexTree.json")
        return destinationFileUrl
    }
    
    private static var remoteUrlForYandexJson: URL?
    {
        return URL(string: "https://money.yandex.ru/api/categories-list")
    }
}
