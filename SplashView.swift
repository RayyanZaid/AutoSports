//
//  SplashView.swift
//  AutoVolley
//
//  Created by Rayyan Zaid on 7/19/23.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                LoginView()
            } else {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geometry in
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
