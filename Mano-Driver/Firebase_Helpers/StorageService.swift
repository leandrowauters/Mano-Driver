//
//  StorageService.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import FirebaseStorage

struct StorageKeys {
    static let ImagesKey = "images"
}

final class StorageService {
    static var storageRef: StorageReference = {
        let ref = Storage.storage().reference()
        return ref
    }()
    
    static public func postImages(imagesData: [Data], imageNames: [String], completion: @escaping (Error?, [URL]?) -> Void) {
        let nameIndex = 0
        var urls = [URL]()
        imagesData.forEach { (imageData) in
            
            StorageService.postImage(imageData: imageData, imageName: imageNames[nameIndex]) { (error, url) in
                if let error = error {
                    completion(error, nil)
                }
                if let url = url {
                    urls.append(url)
                }
            }
        }
        completion(nil, urls)
    }
    static public func postImage(imageData: Data, imageName: String, completion: @escaping (Error?, URL?) -> Void) {
        let metadata = StorageMetadata()
        let imageRef = storageRef.child(StorageKeys.ImagesKey + "/\(imageName)")
        metadata.contentType = "image/jpg"
        let uploadTask = imageRef
            .putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("upload task error: \(error)")
                } else if let _ = metadata {
                    
                }
        }
        uploadTask.observe(.failure) { (snapshot) in
            //
        }
        uploadTask.observe(.pause) { (snapshot) in
            //
        }
        uploadTask.observe(.progress) { (snapshot) in
            //
        }
        uploadTask.observe(.resume) { (snapshot) in
            //
        }
        uploadTask.observe(.success) { (snapshot) in
            //
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error, nil)
                } else if let url = url {
                    completion(nil, url)
                }
            })
        }
    }
    
    
}

