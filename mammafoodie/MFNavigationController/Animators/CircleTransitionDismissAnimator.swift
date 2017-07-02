import UIKit

class CircleTransitionDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        // Getting from and to view controllers
        guard let toViewControllerDelegate: CircleTransitionPresentAnimationDelegate = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? CircleTransitionPresentAnimationDelegate else {
            return
        }
        
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView: UIView = transitionContext.containerView
        
        //        let factorWidth: CGFloat = toViewControllerDelegate.startCircleFrame.width * 0.4
        //        let factorHeight: CGFloat = toViewControllerDelegate.startCircleFrame.height * 0.4
        let startCircleFrame = toViewControllerDelegate.startCircleFrame
        //        startCircleFrame.origin.x += factorWidth
        //        startCircleFrame.origin.y += factorHeight
        //        startCircleFrame.size.width -= factorWidth
        //        startCircleFrame.size.height -= factorHeight
        
        // adding toVC's view in the current context's containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        // Creating a circle same as the button's frame
        let circleMaskPathInitial: UIBezierPath = UIBezierPath(ovalIn: startCircleFrame)
        //        let extremePoint: CGPoint = CGPoint(x: (startCircleFrame.origin.x-startCircleFrame.size.width/2) - 0, y: (startCircleFrame.origin.y-startCircleFrame.size.height/2) - fromViewController.view.bounds.height)
        //        let radius: CGFloat = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        
        let radius: CGFloat = toViewController.view.bounds.height + 100
        
        // Creating a large enough circle that would cover up the entire screen when in it's final state
        let circleMaskPathFinal: UIBezierPath = UIBezierPath(ovalIn: startCircleFrame.insetBy(dx: -radius, dy: -radius))
        
        // Creating a mask layer
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathInitial.cgPath
        fromViewController.view.layer.mask = maskLayer
        
        // Adding the mask layer animation
        let maskLayerAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.fromValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.toValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self as CAAnimationDelegate
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
        self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
    }
}