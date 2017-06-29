import UIKit

class CircleView: UIView {
    
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        if self.circleLayer != nil {
            self.circleLayer.removeFromSuperlayer()
            self.circleLayer = nil
        }
        if self.circleLayer == nil {
            self.backgroundColor = UIColor.clear
            
            // Use UIBezierPath as an easy way to create the CGPath for the layer.
            // The path should be the entire circle.
            let arcCenter: CGPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
            let circlePath = UIBezierPath(arcCenter: arcCenter,
                                          radius: frame.size.width/2 - 1,
                                          startAngle: -.pi / 2,
                                          endAngle: .pi * 2,
                                          clockwise: true)
            
            // Setup the CAShapeLayer with the path, colors, and line width
            self.circleLayer = CAShapeLayer()
            self.circleLayer.path = circlePath.cgPath
            self.circleLayer.fillColor = UIColor.clear.cgColor
            self.circleLayer.strokeColor = UIColor.red.cgColor
            self.circleLayer.lineWidth = 2;
            
            // Don't draw the circle initially
            self.circleLayer.strokeEnd = 0.0
            
            // Add the circleLayer to the view's layer's sublayers
            layer.addSublayer(self.circleLayer)
        }
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the self.circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        self.circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        self.circleLayer.add(animation, forKey: "animateCircle")
    }
}
