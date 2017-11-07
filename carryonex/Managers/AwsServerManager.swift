//
//  AwsServerManager.swift
//  carryonex
//
//  Created by Xin Zou on 11/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import AWSCognito
import AWSCore
import AWSS3


class AwsServerManager {
    
    static let shared = AwsServerManager()
    
    private init(){
        // Configure AWS Cognito credentials:
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: awsIdentityPoolId)
        let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
}

extension AwsServerManager {
    
    public func uploadFile(fileName: String, imgIdType: ImageTypeOfID, localUrl: URL, completion: @escaping(Error?, URL?) -> Void) {
        print("prepareUploadFile: \(fileName), imgIdType: \(imgIdType.rawValue)")
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        let countryCode = currUser.phoneCountryCode ?? "noCtyCode"
        let phone = currUser.phone ?? "noPhoneNum"
        let userPhone = countryCode + "-" + phone
        
        // setup AWS Transfer Manager Request:
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        if imgIdType == .profile {
            uploadRequest?.acl = .publicReadWrite
            uploadRequest?.bucket = "\(awsPublicBucketName)/userProfileImages/\(userPhone)" // no / at the end of bucket
        } else if imgIdType == .requestImages {
            uploadRequest?.acl = .publicReadWrite
            uploadRequest?.bucket = "\(awsPublicBucketName)/RequestPhotos/\(userPhone)" // no / at the end of bucket
        } else {
            uploadRequest?.acl = .private
            uploadRequest?.bucket = "\(awsBucketName)/userIdPhotos/\(userPhone)" // no / at the end of bucket
        }
        uploadRequest?.key = fileName // MUST NOT change this!!
        uploadRequest?.body = localUrl //imageUploadSequence[imgIdType]!! 
        uploadRequest?.contentType = "image/jpeg"
        
        guard let request = uploadRequest else {
            print("error: uploadFile(fileName: -get nil in AWSS3TransferManagerUploadRequest, returning...")
            return
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith { (task: AWSTask) -> Any? in
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
            if let err = task.error, let req = uploadRequest {
                print("performFileUpload(): task.error = \(err), target bucket = \(req.bucket.debugDescription)")
                completion(err, nil)
                return nil
            }
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                if let publicURL = url?.appendingPathComponent(request.bucket!).appendingPathComponent(request.key!) {
                    print("AwsServerManager: task.result get publicURL.str = \(publicURL.absoluteString)")
                    completion(nil, publicURL)
                }
            }else{
                print("errrorrr!!! task.result is nil, !!!! did not upload")
            }
            
            return nil
        }
    }

    
}
