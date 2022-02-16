//
//  ViewController.swift
//  HW12
//
//  Created by Artem Mazurkevich on 07.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var wheelView: CircleView!
    private let circleDiameter = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupWheelView()
        moveCircleView()
        rotateCircleView()
    }
    
    private func setupWheelView() {
        wheelView = CircleView()
        wheelView.frame = CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "wheel")
        imageView.image = image
        
        wheelView.addSubview(imageView)
        view.addSubview(wheelView)
    }
    
    private func rotateCircleView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            self.wheelView.transform = self.wheelView.transform.rotated(by: -.pi / 2)
        } completion: { finished in
            self.rotateCircleView()
        }
    }
    
    private func moveCircleView() {
        let destination = getNewPosition(currentPosition: wheelView.position)
        wheelView.position = destination.position
        
        UIView.animate(withDuration: destination.duration, delay: 0, options: [.curveLinear]) {
            self.wheelView.frame = destination.frame
        } completion: { finished in
            self.moveCircleView()
        }
    }
    
    private func getNewPosition(currentPosition: Position) -> Destination {
        switch currentPosition {
        case .topLeft:
            return Destination(position: .topRight, frame: CGRect(x: view.frame.width - circleDiameter, y: 0, width: circleDiameter, height: circleDiameter), duration: 2)
        case .topRight:
            return Destination(position: .bottomRight, frame: CGRect(x: view.frame.width - circleDiameter, y: view.frame.height - circleDiameter, width: circleDiameter, height: circleDiameter), duration: 4)
        case .bottomRight:
            return Destination(position: .bottomLeft, frame: CGRect(x: 0, y: view.frame.height - circleDiameter, width: circleDiameter, height: circleDiameter), duration: 2)
        case .bottomLeft:
            return Destination(position: .topLeft, frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter), duration: 4)
        }
    }
}

