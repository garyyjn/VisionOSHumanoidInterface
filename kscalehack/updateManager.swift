//
//  updateManager.swift
//  kscalehack
//
//  Created by Gary Yao on 1/18/25.
//

import Foundation
import ARKit
import RealityKit

@MainActor
class UpdateHandler {
    
    private let arkitSession = ARKitSession()
    var handTracking:HandTrackingProvider
    var handModel:HandViewModel
    init(handModel:HandViewModel) {
        self.handModel = handModel
        self.handTracking = HandTrackingProvider()
    }

    func setupArKit() async {
        do {
            try await arkitSession.run([handTracking])
        } catch {
            print("Error: \(error)")
        }
    }

    func updateHandOnTickFrequency(tickFrequency: UInt64) {
        Task {
            while true {
                try? await Task.sleep(nanoseconds: tickFrequency)
                if let leftHand = self.handTracking.latestAnchors.leftHand{
                    for joint in HandSkeleton.JointName.allCases{
                        guard let tip = leftHand.handSkeleton?.joint(joint) else{
                            continue
                        }
                        let location = getlocation(jointloc: leftHand.originFromAnchorTransform, parentloc: tip.anchorFromJointTransform)
                        
                        handModel.leftHandDisplayDictionary[joint.description]?.transform.translation = SIMD3(x: location.x, y: location.y, z: location.z)
                    }
                }
                
                if let rightHand = self.handTracking.latestAnchors.rightHand{
                    for joint in HandSkeleton.JointName.allCases{
                        guard let tip = rightHand.handSkeleton?.joint(joint) else{
                            continue
                        }
                        let location = getlocation(jointloc: rightHand.originFromAnchorTransform, parentloc: tip.anchorFromJointTransform)
                        
                        handModel.rightHandDisplayDictionary[joint.description]?.transform.translation = SIMD3(x: location.x, y: location.y, z: location.z)
                    }
                }
            }
        }
    }

    func awaitAndUpdateHand() async {
        for await anchorUpdate in handTracking.anchorUpdates {
            if let leftHand = self.handTracking.latestAnchors.leftHand{
                for joint in HandSkeleton.JointName.allCases{
                    guard let tip = leftHand.handSkeleton?.joint(joint) else{
                        continue
                    }
                    let location = getlocation(jointloc: leftHand.originFromAnchorTransform, parentloc: tip.anchorFromJointTransform)
                    
                    handModel.leftHandDisplayDictionary[joint.description]?.transform.translation = SIMD3(x: location.x, y: location.y, z: location.z)
                }
            }
            
            if let rightHand = self.handTracking.latestAnchors.rightHand{
                for joint in HandSkeleton.JointName.allCases{
                    guard let tip = rightHand.handSkeleton?.joint(joint) else{
                        continue
                    }
                    let location = getlocation(jointloc: rightHand.originFromAnchorTransform, parentloc: tip.anchorFromJointTransform)
                    
                    handModel.rightHandDisplayDictionary[joint.description]?.transform.translation = SIMD3(x: location.x, y: location.y, z: location.z)
                }
            }
            
        }
        
         
    }
    func getlocation(jointloc: simd_float4x4, parentloc: simd_float4x4) -> simd_float4 {
        return matrix_multiply(jointloc, parentloc).columns.3
    }
}

