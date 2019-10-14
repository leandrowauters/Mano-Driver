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
    
    static public func postImages(imagesData: [Data], imageName: String,  completion: @escaping(Error?, [URL]?) -> Void) {
        var urls = [URL]()
        var counter = 0
        for imageData in imagesData {
            
            let metadata = StorageMetadata()
            var imageRef = StorageReference()
            if counter == 0 {
                imageRef = storageRef.child(StorageKeys.ImagesKey + "/\(imageName)" + "car")
            } else {
                imageRef = storageRef.child(StorageKeys.ImagesKey + "/\(imageName)")
            }
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
                        if counter == 0 {
                            urls.append(url)
                            counter += 1
                        } else {
                            urls.append(url)
                            completion(nil,urls)
                        }
                    }
                })
            }
        }
    }
    
}

