//
//  TransitionAnimator.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/22.
//

import UIKit
//enum으로 트랜지션 정의

protocol TransitionAnimator {
    var duration: TimeInterval { get set }
    var isPresenting: Bool { get set }
    
    func transitioningAnimator(isPresenting: Bool) -> Self?
}
