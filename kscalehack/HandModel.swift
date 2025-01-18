import Foundation
import ARKit
import RealityKit
import RealityKitContent

class HandViewModel: ObservableObject{
    var baseEntity = Entity()
    var leftHandBaseEntity = Entity()
    var rightHandNaseEntity = Entity()
    var leftHandDisplayDictionary:[String:Entity] = [:]
    var rightHandDisplayDictionary:[String:Entity] = [:]
    

    
    var left_relative_transform = Transform()
    var right_relative_transform = Transform()
    
    init() {
        baseEntity.addChild(leftHandBaseEntity)
        baseEntity.addChild(rightHandNaseEntity)
        for joint in HandSkeleton.JointName.allCases{
            print("\"\(joint.description)\",")
            let curr_left_entity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [SimpleMaterial(color: .blue, isMetallic: false)])
            let curr_right_entity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [SimpleMaterial(color: .blue, isMetallic: false)])
            leftHandBaseEntity.addChild(curr_left_entity)
            rightHandNaseEntity.addChild(curr_right_entity)
            leftHandDisplayDictionary[joint.description] = curr_left_entity
            rightHandDisplayDictionary[joint.description] = curr_right_entity
        }
    }

   
}
