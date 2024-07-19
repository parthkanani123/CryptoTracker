//
//  LocalFileManager.swift
//  Crypto
//
//  Created by parth kanani on 08/07/24.
//

import Foundation
import SwiftUI

class LocalFileManager
{
    static let instance = LocalFileManager()
    
    // we are using the singleton instance of this class so we have make init private, so that we can't able to initialie it out side of this class
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String)
    {
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard let data = image.pngData(), let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        
        // save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("DEBUG: Error saving image. ImageName: \(imageName) - \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage?
    {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
        FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String)
    {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }
        
        // if folder does not exists we are going to create it
        if !FileManager.default.fileExists(atPath: url.path)
        {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("DEBUG: Error creating directory. FolderName: \(folderName) - \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL?
    {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL?
    {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
