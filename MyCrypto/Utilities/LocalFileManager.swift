//
//  LocalFileManager.swift
//  MyCrypto
//
//  Created by Marco on 2024-11-07.
//

import Foundation
import UIKit

class LocalFileManager {
    static let instance = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage, folderName: String, imageName: String) {
        // create Folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImageFile(imageName: imageName, folderName: folderName) else {
            return
        }
        
        // save image
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving the image. \(imageName). \(error)")
        }
                
    }
    
    func getImage(folderName: String, imageName: String) -> UIImage? {
        guard let url = getURLForImageFile(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {return}
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: .none)
            } catch let error {
                print("Error creating directory. \(folderName). \(error)")
            }
            
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName, conformingTo: .folder)
    }
    
    private func getURLForImageFile(imageName: String, folderName: String) -> URL? {
        guard let url = getURLForFolder(folderName: folderName) else {return nil}
        return url.appendingPathComponent(imageName, conformingTo: .png)
    }
}
