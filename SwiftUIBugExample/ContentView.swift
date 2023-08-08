//
//  ContentView.swift
//  SwiftUIBugExample
//
//  Created by Petr Pavlik on 08.08.2023.
//

import SwiftUI

public extension Color {
    @inlinable init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

public struct PrimaryJackdButtonStyle: ButtonStyle {

    private let isLoading: Bool

    public init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .font(Font.system(size: 16.0).weight(.heavy))
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding(13)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .frame(minWidth: 175, maxWidth: .infinity)
            .background(
                // BUG: tapping on the buttons makes it disappear Xcode 14.3.1
                // Reproduced on both iOS 16.6 device and Xcode 14.3.1 simulator. Even when running in SwiftUI preview.
               // wrapping `LinearGradient` in a view, such as Group or ZStack fixes the issue
                LinearGradient(gradient: Gradient(colors: [Color(hex: 0xDF123A), Color(hex: 0xFC7517)]), startPoint: .leading, endPoint: .trailing)
                .opacity(configuration.isPressed ? 0.5 : 1)
            )
            .cornerRadius(25)
            .foregroundColor(isLoading ? .clear : .white)
            .allowsHitTesting(!isLoading)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Test") {
                
            }.buttonStyle(PrimaryJackdButtonStyle())
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
