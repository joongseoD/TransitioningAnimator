//
//  GrowingViewAnimationTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class GrowingViewAnimationTransitioning: NSObject, TransitionAnimator {
    var duration: TimeInterval = 0.2
    var isPresenting: Bool = false
    var originFrame = CGRect.zero
    
    init(initialFrame: CGRect) {
        self.originFrame = initialFrame
    }
    
    func transitioningAnimator(isPresenting: Bool) -> Self? {
        self.isPresenting = isPresenting
        return self
    }
}

extension GrowingViewAnimationTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let nextView = isPresenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
        let initalFrame = isPresenting ? originFrame : nextView.frame
        let finalFrame = isPresenting ? nextView.frame : originFrame
        
        let xScaleFactor = originFrame.width / nextView.frame.width
        let yScaleFactor = originFrame.height / nextView.frame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if isPresenting {
            nextView.alpha = 0.7
            nextView.transform = scaleTransform
            nextView.center = CGPoint(x: initalFrame.midX, y: initalFrame.midY)
            nextView.layer.cornerRadius = 20 / xScaleFactor
        }
        
        let containerView = transitionContext.containerView
        if let to = transitionContext.view(forKey: .to) {
            containerView.addSubview(to)
        }
        containerView.bringSubviewToFront(nextView)
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            nextView.transform = self.isPresenting ? .identity : scaleTransform
            nextView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            nextView.alpha = self.isPresenting ? 1 : 0.7
            nextView.layer.cornerRadius = self.isPresenting ? 0 : 20 / xScaleFactor
            
        } completion: { result in
            transitionContext.completeTransition(result)
        }
    }
}
