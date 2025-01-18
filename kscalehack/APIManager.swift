//
//  APIManager.swift
//  kscalehack
//
//  Created by Gary Yao on 1/18/25.
//
import SwiftUI


class NodeJsUpdateModule{
    let target_ip = "http://127.0.0.1:5001"
    var handModel:HandViewModel
    var url:URL
    init(handmodel:HandViewModel) {
        self.handModel = handmodel
        
        self.url = URL(string: target_ip)!
    }
    func startSyncing(freq:UInt64 = 200_000_000){
        Task{
            try await Task.sleep(nanoseconds: freq)
            await syncScene()
        }
    }
    
    func encode_hands() -> [String:String]{
        var ret:[String:String] = [:]
        for (key, val) in handModel.leftHandDisplayDictionary{
            let transform = val.transform
            ret["left \(key.description)"] = String("[\(transform.translation.x)][\(transform.translation.y)][\(transform.translation.z)]")
        }
        for (key, val) in handModel.rightHandDisplayDictionary{
            let transform = val.transform
            ret["right \(key.description)"] = String("[\(transform.translation.x)][\(transform.translation.y)][\(transform.translation.z)]")
        }
        return ret
        
    }
    
    
    func syncScene() async{
        
        var json: [String: Any] = ["text":["test_key_1" : "val_1",
                                           "test_key_2" : "val_2"]]
        
        let handEncodingResult = self.encode_hands()
        
        do {
            json["hands_encoding"] = handEncodingResult
        } catch {
            print("Error writing document: \(error)")
        }
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Create and perform the network task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Print the response (you can use this to check if the request was successful)
            let responseString = String(data: data, encoding: .utf8)
            print("Response: \(responseString ?? "No response")")
        }
        
        task.resume()
        
        
    }
    
    
}
