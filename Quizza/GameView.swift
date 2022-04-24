//
//  GameView.swift
//  Quizza
//
//  Created by Paul Kirnoz on 22.04.2022.
//

import Foundation
import SwiftUI

struct GameView: View {
    
    @State private var currentBackgroundColor = CustomColors.natureColorBackground
    @State private var currentButtonColor = CustomColors.natureColor
    @State private var animationAmount = 1.0
    @State private var currentTopic = "Nature"
    @State private var timeRemaining = 60
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isTimerRunning = false
    @State private var startTime =  Date()
    @State private var timerString = "0.00"
    
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(currentBackgroundColor)).ignoresSafeArea()
                
                VStack {
                    Text("What's your name?")
                        .padding([.leading, .trailing])
                        .foregroundColor(.white)
                        .font(.custom("Jost-LightItalic", size: 30))
                    
                    Spacer()
                    
                    ZStack {
                        
                        ZStack {
                            Circle()
                                .frame(width: 200, height: 200, alignment: .center)
                                .foregroundColor(currentButtonColor)
                                .clipShape(Circle())
                                .blur(radius: 10)
                                .overlay(
                                    Circle()
                                        .stroke(currentButtonColor).blur(radius: 3)
                                        .frame(width: 160, height: 160)
                                        .scaleEffect(animationAmount)
                                        .opacity(2 - animationAmount)
                                        .animation(
                                            .easeInOut(duration: 1)
                                            .repeatForever(autoreverses: false),
                                            value: animationAmount
                                        )
                                )
                                .overlay(
                                    Circle()
                                        .stroke(currentButtonColor).blur(radius: 3)
                                        .frame(width: 150, height: 150)
                                        .scaleEffect(animationAmount)
                                        .opacity(2 - animationAmount)
                                        .animation(
                                            .easeInOut(duration: 1)
                                            .repeatForever(autoreverses: false),
                                            value: animationAmount
                                        )
                                )
                            
                                .overlay(
                                    Circle()
                                        .stroke(currentButtonColor).blur(radius: 3)
                                        .frame(width: 140, height: 140)
                                        .scaleEffect(animationAmount)
                                        .opacity(2 - animationAmount)
                                        .animation(
                                            .easeInOut(duration: 1)
                                            .repeatForever(autoreverses: false),
                                            value: animationAmount
                                        )
                                )
                                .onAppear {
                                    animationAmount = 2
                                }
                        }
                        
                        Text("\(timeRemaining)")
                            .font(.custom("Jost-SemiBold", size: 35))
                            .foregroundColor(.white)
                            .onReceive(timer) { time in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                            .onAppear() {
                                // no need for UI updates at startup
                                self.stopTimer()
                            }
                    }
                    Spacer()
                    Spacer()
                }
            }
           
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isTimerRunning {
                            // stop UI updates
                            self.stopTimer()
                        } else {
                            timerString = "60"
                            startTime = Date()
                            // start UI updates
                            self.startTimer()
                        }
                        isTimerRunning.toggle()
                    } label: {
                        if isTimerRunning {
                            Image(systemName: "pause.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "play.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            
            
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewInterfaceOrientation(.portrait)
    }
}
