//
//  ContentView.swift
//  Quizza
//
//  Created by Paul Kirnoz on 18.04.2022.
//README:
/*
 1. Load custom fonts (Jost) DONE!
 
 2. Add tabView with tab Items
 2.1. Create a page for each tab
 
 3. Create array of questions under each of topics
 
 4. Create logic
 4.1. create working prototype
 4.2. Button, Timer, Pause/Unpause, Refresh
 
 5. Create a custom swipe action to change topics
 -horizontalScrollView/SwipeGesture
 
 6. Create a pallette for each topic: "Nature", "Science", "Sports", "Misc", "Arts", "Geography"
 6.1. attach a pallette to each topic (dictionary? custom struct/class property?) Google: "custom property"
 7. Create foreach for each topic
 */

import SwiftUI
import Combine

struct ContentView: View {
    let topics = ["Nature", "Science", "Sports", "Misc", "Arts", "Geography"]
    @State private var currentTopic = "Nature"
    @State private var currentTitle = "Quizza"
    @State private var currentButtonTitle = "START"
//    @State private var question = "Name types of trees"
    
    
//MARK: Colors
    @State private var currentButtonColor = CustomColors.natureColor
    @State private var currentBackgroundColor = CustomColors.natureColorBackground
    
    
//MARK: Animations
    @State private var controlsAreHidden = true
    @State private var fadeInOutTitle = false
    @State private var buttonFade = false
    @State private var animationAmount = 1.0
    
//MARK: Timer
    @State private var timeRemaining = 60
    @State private var timer = Timer.publish(every: 1, on: .main, in:.common).autoconnect()
    @State var isTimerRunning = true
    @State private var startTime =  Date()
    @State private var connectedTimer: Cancellable? = nil
    
    func instantiateTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        return
    }
    
    func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }
    
    func resetCounter() {
        self.timeRemaining = 60
        return
    }
    
    func restartTimer() {
        self.resetCounter()
        self.cancelTimer()
        self.instantiateTimer()
        return
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func gameStarts() {
        withAnimation(.interpolatingSpring(stiffness: 10, damping: 5)) {
            
            currentTopic = quizQuestion
            fadeInOutTitle.toggle()
            buttonFade.toggle()
            currentButtonTitle = ""
            restartTimer()
        }
    }
    
    func gameEnds() {
        withAnimation(.interpolatingSpring(stiffness: 10, damping: 5)) {
            
            currentTopic = "Nature"
            fadeInOutTitle.toggle()
            controlsAreHidden.toggle()
            stopTimer()
            restartTimer()
        }
            currentButtonTitle = "START"
        

    }
    
//MARK: Questions
@State private var quizQuestion = ""
    
    func populateQuestion() {
        
        if let startQuestionsURL = Bundle.main.url(forResource: "questions", withExtension: "txt") {
            
            if let startQuestion = try? String(contentsOf: startQuestionsURL) {
                
                let allQuestions = startQuestion.components(separatedBy: "\n")
                
                quizQuestion = allQuestions.randomElement() ?? "Oh wow I couldn't upload questions..."
                return
            }
        }
        fatalError("Could not load questions from bundle.")
        
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color(UIColor(currentBackgroundColor)).ignoresSafeArea()
                    //background color
                
                VStack {
                    VStack(spacing: 10) {
                        
                        Text(currentTitle)
                            .foregroundColor(.white)
                            .font(.custom("Jost-SemiBoldItalic", size: 60))
                            .opacity(fadeInOutTitle ? 0 : 1)
                        
                        
                        Text(currentTopic)
                            .padding([.leading, .trailing])
                            .foregroundColor(.white)
                            .font(.custom("Jost-LightItalic", size: 30))
                            .border(.black, width: 5)
                            
                    }
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
                            .opacity(controlsAreHidden ? 0 : 1)
                            .font(.custom("Jost-SemiBold", size: 35))
                            .foregroundColor(.white)
                            .onReceive(timer) { time in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                        
                            .onAppear() {
                                self.stopTimer()
                            }
                        
                        Button(currentButtonTitle) {

                            buttonFade.toggle()
                            populateQuestion()
                            gameStarts()
                            withAnimation(.easeInOut) {
                                controlsAreHidden.toggle()
                            }

                        }
                        .foregroundColor(.white)
                        .font(.custom("Jost-SemiBold", size: 30))
                        .opacity(buttonFade ? 0 : 1)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isTimerRunning {
                            
                            self.stopTimer()
                            
                        } else {
                            
                            self.startTimer()
                        }
                        isTimerRunning.toggle()
                        
                    } label: {
                        
                        if isTimerRunning {
                            Image(systemName: "pause.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                        } else if !isTimerRunning {
                            Image(systemName: "play.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(controlsAreHidden ? 0 : 1)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        gameEnds()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .opacity(controlsAreHidden ? 0 : 1)
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.light)
    }
}
