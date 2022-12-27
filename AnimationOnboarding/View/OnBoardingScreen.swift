//
//  OnBoardingScreen.swift
//  AnimationOnboarding
//
//  Created by Waris on 2022/12/27.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    //MARK: OnBoarding Slide Model Dat
    @State var onboardingItems: [OnboardingItem] = [
        .init(title: "كۈچەيىتىلمە رىئاللىق ھاۋارايى ئەپى", subTitle: "سىزنى كۈچەيىتلمە رىئاللىق تەسۋىرىدىن تاللىغان شەھەرنىڭ ھاۋارايى مەلۇماتىنى كۆرەلەيسىز", lottieView: .init(name: "arsearch", bundle: .main)),
        .init(title: "24سائەتلىك ھاۋارايىنى بىلەلەيسىز", subTitle: "ئەپىمىزگە ئالمىنىڭ ئەڭ يېڭى WeatherKit ئىشلىتىلگەن بولۇپ ھەر بىر سائەتنىڭ ھاۋارايى ئالدىن مەلۇماتىنى بىلەلەيسىز", lottieView: .init(name: "daynight", bundle: .main)),
        .init(title: "ئاساسىي مەزمۇنلار ئۇيغۇرچە", subTitle: "كۆرۈنمە يۈزلىرى ۋە ئىشلىتىش ئورۇنلىرى ئۇيغۇرچە ئۇچۇر كۆرۈنىدۇ ", lottieView: .init(name: "weather", bundle: .main))
    ]
    //MARK: Current Slide index
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            HStack(spacing: 0){
                ForEach($onboardingItems) { $item in
                    let isLastSlide = (currentIndex == onboardingItems.count - 1)
                    VStack {
                        //MARK: Top Nav bar
                        HStack{
                            Button("قايتىش"){
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                    playAnimation()
                             
                                }
                            }
                            .opacity(currentIndex > 0 ? 1 : 0)
                            
                            Spacer(minLength: 0)
                            Button("ئۆتكۈزۈش"){
                                currentIndex = onboardingItems.count - 1
                                playAnimation()
                            }
                            .opacity(isLastSlide ? 0 : 1)
                        }
                        .animation(.easeInOut, value: currentIndex)
                        .tint(Color("Blue"))
                        .font(.custom(uyghur, size: 14))
                        //.padding()
                        
                        //MARK: Movable Slides
                        VStack(spacing: 15){
                            let offset = -CGFloat(currentIndex) * size.width
                            //MARK: Resizeble Lottie file
                            ResizableLottieView(onboardingItem: $item)
                                .frame(height: size.width)
                                .onAppear{
                                    //MARK: Intially playing first slide animation
                                    if currentIndex == indexOf(item){
                                        item.lottieView.play(toProgress: 0.7)
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                            
                            Text(item.title)
                                .font(.custom(uyghur, size: 22))
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)
                            
                            Text(item.subTitle)
                                .font(.custom(uyghur, size: 18))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 15)
                                .foregroundColor(.gray)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: currentIndex)
                        }
                        
                        Spacer(minLength: 0)
                      
                        
                        //MARK: Next / Login Button
                        VStack(spacing: 15) {
                            Text(isLastSlide ? "مەرھەمەت" : "كېيىنكى")
                                .font(.custom(uyghur, size: 16))
                                .foregroundColor(.white)
                                .padding(.vertical,isLastSlide ? 13 :  12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color("Blue"))
                                }
                            //MARK: Button Horizontal size
                                .padding(.horizontal, isLastSlide ? 30 : 100)
                                .onTapGesture {
                                    //MARK: Updating t next index
                                    if currentIndex < onboardingItems.count - 1{
                                        //MARK: Pausing Previous animation
                                        let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
                                        onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
                                        currentIndex += 1
                                        //MARK: Playing next animation from start
                                       playAnimation()
                                    }
                                }
                            
                            HStack{
                                Text("مەخپىيەتلىك تۈزۈمى")
                                
                                Text("ئىشلىتىش شەرتلىرى ")
                                   
                            }
                            .font(.custom(uyghur, size: 14))
                            .underline(true, color: .primary)
                            .offset(y: 5)
                        }
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(    15)
                    .frame(width: size.width, height: size.height)
                }
            }
            .frame(width: size.width * CGFloat(onboardingItems.count),alignment: .trailing)
        }
    }
    
    func playAnimation(){
        onboardingItems[currentIndex].lottieView.currentProgress = 0
        onboardingItems[currentIndex].lottieView.play(toProgress: 0.7)
    }
    
    //MARK: Retreving Index of the item in the array
    func indexOf(_ item: OnboardingItem)->Int{
        if let index = onboardingItems.firstIndex(of: item){
            return index
        }
        return 0
            
    }
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


let uyghur = "UKIJ Tuz Tom"

//MARK: Resizble lottie view without background
struct ResizableLottieView: UIViewRepresentable{
    @Binding var onboardingItem: OnboardingItem
    func makeUIView(context: Context) ->  UIView {
        let view  = UIView()
        view.backgroundColor = .clear
        setupLottieView(view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func setupLottieView(_ to: UIView) {
        let lottieView = onboardingItem.lottieView
        lottieView.backgroundColor = .clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: Applying Constraints
        let contraints = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor),
        ]
        to.addSubview(lottieView)
        to.addConstraints(contraints)
    }
}
