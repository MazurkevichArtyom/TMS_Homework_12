//
//  ViewController.swift
//  HW12-3
//
//  Created by Artem Mazurkevich on 13.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let imagesNames = ["nissan_skyline_r34_gt", "toyota_supra", "subaru_impreza_wrx", "nissan_180_sx", "toyota_ae86"]
    private var centerImageViewIndex = 1
    private var centerImageIndex = 1
    
    private var galleryView: UIView?
    private var japanView: UIView?
    private var imageViews: [UIImageView]?
    
    private var imageSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupImagesGallery()
        setupFrames(size: view.frame.size, isFirstUpdate: true)
        fillData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupFrames(size: size)
    }
    
    @objc private func onSwipe(gesture: UISwipeGestureRecognizer) {
        moveImages(direction: gesture.direction)
    }
    
    private func setupImagesGallery() {
        let japan = UIView()
        japan.backgroundColor = .systemRed
        japanView = japan
        view.addSubview(japan)
        
        let gallery = UIView()
        gallery.backgroundColor = .systemOrange
        galleryView = gallery
        view.addSubview(gallery)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipeLeft.direction = .left
        
        gallery.addGestureRecognizer(swipeRight)
        gallery.addGestureRecognizer(swipeLeft)
        
        let firstImageView = createImageView()
        let seconfImageView = createImageView()
        let thirdImageView = createImageView()
        let fourthImageView = createImageView()
        
        imageViews = [firstImageView, seconfImageView, thirdImageView, fourthImageView]
        
        gallery.addSubview(firstImageView)
        gallery.addSubview(seconfImageView)
        gallery.addSubview(thirdImageView)
        gallery.addSubview(fourthImageView)
    }
    
    private func setupFrames(size: CGSize, isFirstUpdate: Bool = false) {
        guard let galleryView = galleryView else {
            return
        }
        
        guard let imageViews = imageViews else {
            return
        }
        
        guard let japanView = japanView else {
            return
        }
        
        let japanViewSize = size.width * 0.8
        japanView.frame = CGRect(x: (size.width - japanViewSize) / 2.0, y: (size.height - japanViewSize) / 2.0, width: japanViewSize, height: japanViewSize)
        japanView.layer.cornerRadius = japanViewSize / 2.0
        
        let imageWidth = size.width * 0.5
        let imageHeight = imageWidth * 9.0 / 16.0
        
        imageSize = CGSize(width: imageWidth, height: imageHeight)
        
        var startX = -imageWidth / 2.0
        
        let sortedArray = imageViews.sorted(by: { $0.center.x < $1.center.x})
        guard let firstImageView = sortedArray.first else {
            return
        }
        
        if !isFirstUpdate && firstImageView.center.x != 0 {
            startX -= imageWidth
        }
        
        galleryView.frame = CGRect(x: 0, y: (size.height - imageHeight) / 2.0, width: size.width, height: imageHeight)
        
        for imageView in sortedArray {
            imageView.frame = CGRect(x: startX, y: 0, width: imageWidth, height: imageHeight)
            startX += imageWidth
        }
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }
    
    private func fillData() {
        guard let imageViews = imageViews else {
            return
        }
        
        for (index, imageView) in imageViews.enumerated() {
            let image = UIImage(named: imagesNames[index % imagesNames.count])
            imageView.image = image
        }
    }
    
    private func moveImages(direction: UISwipeGestureRecognizer.Direction) {
        guard let gallery = galleryView else {
            return
        }
        
        guard let images = imageViews else {
            return
        }
        
        guard let imageSize = imageSize else {
            return
        }
        
        var offsetX = 0.0
        var newImageViewX = 0.0
        var indexOfImageViewForUpdating = 0
        var newImageIndex = 0
        
        switch direction {
        case .left:
            offsetX = -imageSize.width
            newImageViewX = view.frame.width + imageSize.width / 2.0
            centerImageViewIndex = (centerImageViewIndex + 1) % images.count
            centerImageIndex = (centerImageIndex + 1) % imagesNames.count
            indexOfImageViewForUpdating = (centerImageViewIndex + 1) % images.count
            newImageIndex = (centerImageIndex + 1) % imagesNames.count
        case .right:
            offsetX = imageSize.width
            newImageViewX = -3.0 * imageSize.width / 2.0
            centerImageViewIndex = (centerImageViewIndex - 1 + images.count) % images.count
            centerImageIndex = (centerImageIndex - 1 + imagesNames.count) % imagesNames.count
            indexOfImageViewForUpdating = (centerImageViewIndex - 1 + images.count) % images.count
            newImageIndex = (centerImageIndex - 1 + imagesNames.count) % imagesNames.count
        default:
            print("incorrect direction")
        }
        
        let imageView = images[indexOfImageViewForUpdating]
        
        if imageView.frame.origin.x != newImageViewX {
            imageView.image = UIImage(named: imagesNames[newImageIndex])
            imageView.center = CGPoint(x: newImageViewX + imageSize.width / 2.0, y: imageView.center.y)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            for subView in gallery.subviews {
                subView.center = CGPoint(x: subView.center.x + offsetX, y: subView.center.y)
            }
        }
    }
}

