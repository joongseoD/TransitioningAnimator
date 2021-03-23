//
//  MovingSelectedViewToNextViewTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class MovingSelectedViewToNextViewTransitioning: NSObject, TransitionAnimator {
    var isPresenting = false
    var duration = 0.4
    let selectedView: UIView
    var initalFrame: CGRect
    
    init(selectedView: UIView, initalFrame: CGRect) {
        self.selectedView = selectedView
        self.initalFrame = initalFrame
    }
    
    func transitioningAnimator(isPresenting: Bool) -> Self? {
        self.isPresenting = isPresenting
        return isPresenting ? self : nil
    }
}

extension MovingSelectedViewToNextViewTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        containerView.addSubview(toView)
        toView.alpha = 0
        let whiteView = UIView(frame: containerView.bounds)
        whiteView.backgroundColor = .clear
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.addSubview(whiteView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        
        guard let destinationController = transitionContext.viewController(forKey: .to) as? TransitionDestination else { return }
        guard destinationController.animationViews.count >= 2 else { return }
        let destinationView = destinationController.animationViews[0]
        let moveUpView = destinationController.animationViews[1]
        destinationView.alpha = 0
        let destinationViewRect = destinationView.convert(destinationView.bounds, to: destinationController.view)
        let moveUpViewRect = moveUpView.convert(moveUpView.bounds, to: destinationController.view)
        selectedView.frame = initalFrame
        moveUpView.frame = CGRect(x: 0, y: moveUpViewRect.minY, width: moveUpViewRect.width, height: 100)
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.selectedView.frame = destinationViewRect
            moveUpView.frame = moveUpViewRect
            toView.alpha = 1
        } completion: { [weak self] in
            destinationView.alpha = 1
            backgroundView.removeFromSuperview()
            self?.selectedView.removeFromSuperview()
            transitionContext.completeTransition($0)
        }
    }
}
