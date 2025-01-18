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
            let updateHandler = UpdateHandler(handModel: handModel)
            await updateHandler.setupArKit()
            print("setup down")
            Task{
                try await Task.sleep(nanoseconds: 200_000_000)
                updateHandler.updateHandOnTickFrequency(tickFrequency: 100_000_000)
            }
        }
    }
}
