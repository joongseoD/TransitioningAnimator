//
//  TransitionAnimatingStyle.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

enum TransitionAnimatingStyle {
    case movingSelectedViewToNextView(selectedView: UIView, selectedViewFrame: CGRect)
    case growingView(initalFrame: CGRect)
    
    var animator: (UIViewControllerAnimatedTransitioning & TransitionAnimator)? {
        switch self {
        case let .movingSelectedViewToNextView(selectedView, frame):
            return MovingSelectedViewToNextViewTransitioning(selectedView: selectedView, initalFrame: frame)
        case let .growingView(initalFrame):
            return GrowingViewAnimationTransitioning(initialFrame: initalFrame)
        default:
            return nil
        }
    }
}
