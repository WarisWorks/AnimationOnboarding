//
//  OnboardingItem.swift
//  AnimationOnboarding
//
//  Created by Waris on 2022/12/27.
//

import SwiftUI
import Lottie

//MARK: Onboarding Item Model
struct OnboardingItem: Identifiable, Equatable{
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var lottieView: LottieAnimationView = .init()
}
