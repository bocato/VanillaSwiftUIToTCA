//
//  ErrorView.swift
//  VanillaSwiftUIToTCA
//
//  Created by Bocato, Eduardo on 28/01/2022.
//

import SwiftUI


struct ErrorView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        VStack {
            Text(title)
            Button("Retry", action: action)
        }
    }
}
