//
//  ContentView.swift
//  kscalehack
//
//  Created by Gary Yao on 1/18/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @ObservedObject var handModel: HandViewModel
    @Environment(AppModel.self) var appModel: AppModel
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
            
            Text("Left Hand Position: \(handModel.leftHandBaseEntity.position(relativeTo: nil).description)")

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}
