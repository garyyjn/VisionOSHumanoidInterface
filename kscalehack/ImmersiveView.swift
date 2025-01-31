//
//  ImmersiveView.swift
//  kscalehack
//
//  Created by Gary Yao on 1/18/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
@MainActor
struct ImmersiveView: View {
    @ObservedObject var handModel: HandViewModel
    @Environment(AppModel.self) var appModel: AppModel
    
    var body: some View {
        RealityView { content in
            content.add(handModel.baseEntity)
            let updateHandler = UpdateHandler(handModel: handModel)
            let apiHandler = NodeJsUpdateModule(handmodel: handModel)
            await updateHandler.setupArKit()
            print("setup done")
            Task{
                try await Task.sleep(nanoseconds: 200_000_000)
                updateHandler.updateHandOnTickFrequency(tickFrequency: 100_000_000)
            }
            Task{
                try await Task.sleep(nanoseconds: 300_000_000)
                apiHandler.startSyncing(freq: 100_000_000)
            }
        }
    }
}
