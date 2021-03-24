//
//  SpinSelectedViewAnimationTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class SpinSelectedViewAnimationTransitioning: NSObject, TransitionAnimator {
    var duration = 1.0
    var isPresenting = false
    var selectedView: UIView
    var initialFrame: CGRect = .zero
    init(selectedView: UIView, initialFrame: CGRect) {
        self.selectedView = selectedView
        self.initialFrame = initialFrame
    }
    
    func transitioningAnimator(isPresenting: Bool) -> Self? {
        self.isPresenting = isPresenting
        return isPresenting ? self : nil
    }
}

extension SpinSelectedViewAnimationTransitioning: UIViewControllerAnimatedTransitioning {
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
        
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = .clear
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        selectedView.frame = initialFrame
        guard let destinationController = transitionContext.viewController(forKey: .to) as? TransitionDestination else { return }
        guard let detinationAnimationView = destinationController.animationViews.first else { return }
        let imageViewRect = detinationAnimationView.convert(detinationAnimationView.bounds, to: destinationController.view)
        
        //key frame 
        UIView.animate(withDuration: 0.3) {
            self.selectedView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.selectedView.center = containerView.center
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.3) { [weak self] in
            self?.selectedView.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.6) { [weak self] in
            self?.selectedView.transform = .identity
            self?.selectedView.frame = imageViewRect
            
        } completion: {  [weak self] in
            toView.alpha = 1
            backgroundView.removeFromSuperview()
            self?.selectedView.removeFromSuperview()
            transitionContext.completeTransition($0)
        }

    }
}
