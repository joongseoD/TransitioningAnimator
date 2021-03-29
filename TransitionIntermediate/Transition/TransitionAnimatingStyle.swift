//
//  TransitionAnimatingStyle.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

enum TransitionAnimatingStyle {
    typealias AnimatedTransitioning = UIViewControllerAnimatedTransitioning & TransitionAnimator
    
    case movingSelectedViewToNextView(selectedView: UIView, selectedViewFrame: CGRect)
    case growingView(initalFrame: CGRect)
    case spinSelectedView(_ view: UIView, frame: CGRect)
    
    func getAnimator(for destination: UIViewController, isPresenting: Bool) -> AnimatedTransitioning? {
        switch self {
        case let .movingSelectedViewToNextView(selectedView, frame):
            return MovingSelectedViewToNextViewTransitioning(selectedView: selectedView, initalFrame: frame, isPresenting: isPresenting)
        case let .growingView(initalFrame):
            return GrowingViewAnimationTransitioning(initialFrame: initalFrame, isPresenting: isPresenting)
        case let .spinSelectedView(view, frame):
            return SpinSelectedViewAnimationTransitioning(selectedView: view, initialFrame: frame, isPresenting: isPresenting)
        }
    }
}

extension TransitionAnimatingStyle: CaseIterable {
    static var allCases: [Self] {
        return [.spinSelectedView(.init(frame: .zero), frame: .zero),
                .growingView(initalFrame: .zero),
                .movingSelectedViewToNextView(selectedView: .init(frame: .zero), selectedViewFrame: .zero)]
    }
}

extension TransitionAnimatingStyle: CustomStringConvertible {
    var description: String {
        switch self {
        case .movingSelectedViewToNextView(selectedView: _, selectedViewFrame: _):
            return "MovingSelectedView"
        case .growingView(initalFrame: _):
            return "Growing"
        case .spinSelectedView(_, frame: _):
            return "SpinSelectedView"
        }
    }
}
