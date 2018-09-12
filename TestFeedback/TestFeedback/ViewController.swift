//
//  ViewController.swift
//  TestFeedback
//
//  Created by Akshay on 23/04/18.
//  Copyright © 2018 Akshay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate
{
    //Closure
   
    override func viewDidLoad() {
        isSSLCertified { (isSucess) in
            if isSucess
            {
              print("success")
            }
        }
    }
    //MARK: - Declarations
    var strInvocationFailurerMsg = ""
    var urlSession: Foundation.URLSession!
    
    //MARK: - Function to invoke procedure
    
    
    
    /// this function is to check for SSL PInning
    ///
    /// - Parameter completion: Boolean
    
    func isSSLCertified(completion:@escaping (_ completed:Bool) -> Void)
    {
        self.configureURLSession()
        self.urlSession?.dataTask(with: URL(string:"https://mobankmf.rblbank.com/mbnewqa/")!, completionHandler: { ( data,  response,  error) -> Void in
            
            //error goes here
            guard let data = data , error == nil else {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    completion(false)  // error occured
                })
                return // guard statement needs return
            }
            //success goes here
            DispatchQueue.main.async(execute: { () -> Void in
                
                completion(true) // SSL Certified , proceed for API call
                
            })
        }).resume()
        
    }
    
    
    //Function to Invoke Procedure
    
    //MARK: - Check Internet
    func checkInternet() -> Bool
    {
        return true
        
    }
    
    //MARK: - nsurl delegate method
    func configureURLSession() {
        self.urlSession = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    // MARK: URL session delegate
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        //copyCertificateFromBundleTofileSystem()
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString?)))
        SecTrustSetPolicies(serverTrust!, policies);
        
        // Evaluate server certificate
        var result: SecTrustResultType = SecTrustResultType(rawValue: UInt32(0))!
        SecTrustEvaluate(serverTrust!, &result)
        let isServerTrusted:Bool = (Int((result).rawValue) == Int(SecTrustResultType.unspecified.rawValue) || Int((result).rawValue) == Int(SecTrustResultType.proceed.rawValue))
        
        
        // Get local and remote cert data
        let remoteCertificateData:Data = SecCertificateCopyData(certificate!) as Data
        
         var localdatacertificate:Data!
         saveCertDocumentDirectory(data: remoteCertificateData)
         let fileManager = FileManager.default
        
        let certPath = getFilePathFromFileName(filename: "Certificate.cer")
        let localCertificate:Data = try! Data(contentsOf: URL(fileURLWithPath: certPath))
        
        if (isServerTrusted && (remoteCertificateData == localCertificate)) {
            let credential:URLCredential = URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    //MARK: - File operations
    
    /// to get directory path
    ///
    /// - Returns: path string
    func getFilePathFromFileName(filename: String) ->String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent(filename)
        return dataPath
    }
    
    /// save certificate to document directory
    ///
    /// - Parameter data: data of certificate which is downloaded
    func saveCertDocumentDirectory(data:Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Certificate.cer")
        print("--->",paths)
        fileManager.createFile(atPath: paths as String, contents: data as? Data, attributes: nil)
    }
    
   
    
    /// function to convert string into dictionary
    ///
    /// - Parameter text: string
    /// - Returns: dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                
            }
        }
        return nil
    }
    
    /// function to copy certificate from Bundle to doc directory (File system)
    func copyCertificateFromBundleTofileSystem(){
        var success:Bool?
        let fileManager: FileManager = FileManager.default
        
        // Check if the database has already been created in the users filesystem
        success = fileManager.fileExists(atPath: getFilePathFromFileName(filename:"Certificate.cer") as String)
        
        if(success == true) {
            return
        }
        // Get the path to the Certificate in the application package
        let pathToCert = Bundle.main.path(forResource: "Certificate", ofType: "cer")
        
        
        // Copy the database from the package to the users filesystem
        do {
            try fileManager.copyItem(atPath: pathToCert!, toPath: getFilePathFromFileName(filename:"Certificate.cer"))
        }
        catch {
            print("Error in checkAndCreateDatabase")
            /* error handling here */
        }
    }
}


