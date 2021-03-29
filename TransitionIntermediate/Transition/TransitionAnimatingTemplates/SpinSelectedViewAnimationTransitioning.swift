//
//  SpinSelectedViewAnimationTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit
protocol SpinSelectedViewAnimationTransitioningDestination: TransitioningDestination {
    var spinningView: UIView { get }
}
class SpinSelectedViewAnimationTransitioning: NSObject, TransitionAnimator {
    var duration = 1.0
    var isPresenting = false
    var selectedView: UIView
    var initialFrame: CGRect = .zero
    
    init?(selectedView: UIView, initialFrame: CGRect, isPresenting: Bool) {
        guard isPresenting else { return nil }
        self.selectedView = selectedView
        self.initialFrame = initialFrame
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
        guard let destinationController = transitionContext.viewController(forKey: .to) as? SpinSelectedViewAnimationTransitioningDestination else { return }
        let detinationAnimationView = destinationController.spinningView
        let imageViewRect = detinationAnimationView.convert(detinationAnimationView.bounds, to: destinationController.view)
        
        
        UIView.animate(withDuration: duration/3) { [weak self] in
            self?.selectedView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self?.selectedView.center = containerView.center
        } completion: { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: self.duration/3) { [weak self] in
                self?.selectedView.transform = CGAffineTransform(rotationAngle: .pi)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.selectedView.transform = .identity
                UIView.animate(withDuration: self.duration/4) { [weak self] in
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
    }
}
