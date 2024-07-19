//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by parth kanani on 04/07/24.
//

import SwiftUI

struct CircleButtonAnimationView: View 
{
    @Binding var animate: Bool
    
    var body: some View
    {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none,
                       value: UUID())
            // we have done onAppear for this preview only because for preview, we have to initialize animate variable to false
//            .onAppear {
//                animate.toggle()
//            }
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .frame(width: 100, height: 100)
        .foregroundStyle(.red)
}
