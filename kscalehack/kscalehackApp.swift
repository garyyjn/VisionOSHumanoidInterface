//
//  kscalehackApp.swift
//  kscalehack
//
//  Created by Gary Yao on 1/18/25.
//

import SwiftUI

@main
struct kscalehackApp: App {

    @State private var appModel = AppModel()
    @State var handModel = HandViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(handModel:handModel)
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView(handModel:handModel)
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
