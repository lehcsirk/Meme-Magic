//
//  ViewController.swift
//  Meme Magic
//
//  Created by Cameron Krischel on 4/2/19.
//  Copyright © 2019 Cameron Krischel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate
{
    var gradientLayer = CAGradientLayer()
    var gradientLayer2 = CAGradientLayer()
    
    let screenSize = UIScreen.main.bounds
    var img = UIImageView()
    var imagePicker = UIImagePickerController()
    var button = UIButton()
    var copyButton = UIButton()
    var label = UILabel()
    
    var topText = UITextView()
    var botText = UITextView()
    
    var gesture = UIPanGestureRecognizer()
    
    var gestureRecognizer = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotate = UIRotationGestureRecognizer()
    
    var topColor = UIButton()
    var botColor = UIButton()
    
    var save = UIButton()
    
    var savedY = CGFloat(0)
    
    var lightBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
    var darkBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    
    var brightnessSlider = UISlider()
    var contrastSlider = UISlider()
    var saturationSlider = UISlider()
    var noiseSlider = UISlider()
    
    var brightLabel = UILabel()
    var contLabel = UILabel()
    var satLabel = UILabel()
    var noiseLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround(topText, botText)

        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)))
        pinchGesture.delegate = self
        self.view.addGestureRecognizer(pinchGesture)
        
        rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
        rotate.delegate = self
        self.view.addGestureRecognizer(rotate)
        
        imagePicker.delegate = self
        img.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width)
        img.center.y = screenSize.height/2
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.borderWidth = 1.0
        img.layer.zPosition = -1
        self.view.addSubview(img)
        
        topText.isUserInteractionEnabled = true
        topText.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.9, height: screenSize.width/4)
        topText.text = "TOP TEXT"
        topText.textColor = darkBlack
        topText.textAlignment = .center
        topText.centerVertically()
        topText.font = UIFont(name: "impact", size: 1000)
        topText.textContainer.maximumNumberOfLines = 2
        updateTextFont(topText)
        topText.adjustsFontForContentSizeCategory = true
//        topText.layer.borderColor = UIColor.black.cgColor
//        topText.layer.borderWidth = 1.0
        topText.backgroundColor = UIColor.clear
        topText.autocapitalizationType = .allCharacters
        topText.delegate = self as! UITextViewDelegate
        topText.layer.shadowColor = UIColor.white.cgColor
        topText.layer.shadowRadius = 5.0
        topText.layer.shadowOpacity = 1.0
        topText.layer.shadowOffset = CGSize(width: 0, height: 0)
        topText.layer.masksToBounds = false
        topText.isScrollEnabled = false
        
        topText.center.x = screenSize.width/2
        topText.center.y = img.frame.minY + topText.frame.height/2
        self.view.addSubview(topText)
        
        botText.isUserInteractionEnabled = true
        botText.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.9, height: screenSize.width/4)
        botText.text = "BOTTOM TEXT"
        botText.textColor = darkBlack
        botText.textAlignment = .center
        botText.centerVertically()
        botText.font = UIFont(name: "impact", size: 1000)
        botText.textContainer.maximumNumberOfLines = 2
        updateTextFont(botText)
        botText.adjustsFontForContentSizeCategory = true
//        botText.layer.borderColor = UIColor.black.cgColor
//        botText.layer.borderWidth = 1.0
        botText.backgroundColor = UIColor.clear
        botText.autocapitalizationType = .allCharacters
        botText.delegate = self as! UITextViewDelegate
        botText.layer.shadowColor = UIColor.white.cgColor
        botText.layer.shadowRadius = 5.0
        botText.layer.shadowOpacity = 1.0
        botText.layer.shadowOffset = CGSize(width: 0, height: 0)
        botText.layer.masksToBounds = false
        botText.isScrollEnabled = false
        botText.center.x = screenSize.width/2
        botText.center.y = img.frame.maxY - botText.frame.height/2
        self.view.addSubview(botText)
        
        label.frame = CGRect(x: 0, y: 0, width: screenSize.width*3/4, height: screenSize.height/8)
        label.center.x = screenSize.width/2
        label.center.y = (screenSize.height - screenSize.width)/4
        label.text = "MEME MAGIC"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "impact", size: 200)
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.black
        label.layer.shadowColor = UIColor.green.cgColor
        label.layer.shadowRadius = 5.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.masksToBounds = false
        self.view.addSubview(label)
        
        button.frame = CGRect(x: 0, y: 0, width: screenSize.width*1/4, height: screenSize.height/32)
        button.center.x = screenSize.width*6.5/8
        button.center.y = screenSize.height - (screenSize.height - screenSize.width)*3/16
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.setTitle("PICK IMAGE", for: .normal)
        button.titleLabel?.font = UIFont(name: "impact", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(onClickPickImage), for: .touchDown)
        button.layer.shadowColor = UIColor.green.cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
        self.view.addSubview(button)
        
        copyButton.frame = CGRect(x: 0, y: 0, width: screenSize.width*1/4, height: screenSize.height/32)
        copyButton.center.x = screenSize.width*6.5/8
        copyButton.center.y = screenSize.height - (screenSize.height - screenSize.width)*5/16
        copyButton.layer.borderColor = UIColor.black.cgColor
        copyButton.layer.borderWidth = 1.0
        copyButton.setTitle("COPY IMAGE", for: .normal)
        copyButton.titleLabel?.font = UIFont(name: "impact", size: (copyButton.titleLabel?.font.pointSize)!)
        copyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        copyButton.backgroundColor = UIColor.black
        copyButton.setTitleColor(UIColor.white, for: .normal)
        copyButton.addTarget(self, action: #selector(copyImage), for: .touchDown)
        copyButton.layer.shadowColor = UIColor.blue.cgColor
        copyButton.layer.shadowRadius = 5.0
        copyButton.layer.shadowOpacity = 1.0
        copyButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        copyButton.layer.masksToBounds = false
        self.view.addSubview(copyButton)
        
        topColor.frame = CGRect(x: 0, y: 0, width: screenSize.width/16, height: screenSize.width/16)
        topColor.center.x = screenSize.width*7/8
        topColor.center.y = screenSize.height - (screenSize.height - screenSize.width)*1/16
        topColor.layer.borderColor = UIColor.white.cgColor
        topColor.layer.borderWidth = 1.0
        topColor.backgroundColor = UIColor.black
        topColor.setTitle("", for: .normal)
        topColor.setTitleColor(UIColor.black, for: .normal)
        topColor.addTarget(self, action: #selector(toggleColor), for: .touchDown)
        self.view.addSubview(topColor)
        
        botColor.frame = CGRect(x: 0, y: 0, width: screenSize.width/16, height: screenSize.width/16)
        botColor.center.x = screenSize.width*6/8
        botColor.center.y = screenSize.height - (screenSize.height - screenSize.width)*1/16
        botColor.layer.borderColor = UIColor.white.cgColor
        botColor.layer.borderWidth = 1.0
        botColor.backgroundColor = UIColor.black
        botColor.setTitle("", for: .normal)
        botColor.setTitleColor(UIColor.black, for: .normal)
        botColor.addTarget(self, action: #selector(toggleColor), for: .touchDown)
        self.view.addSubview(botColor)
        
        
        save.frame = CGRect(x: 0, y: 0, width: screenSize.width*1/4, height: screenSize.height/32)
        save.center.x = screenSize.width*6.5/8
        save.center.y = screenSize.height - (screenSize.height - screenSize.width)*7/16
        save.layer.borderColor = UIColor.black.cgColor
        save.layer.borderWidth = 1.0
        save.setTitle("SAVE MEME", for: .normal)
        save.titleLabel?.font = UIFont(name: "impact", size: (save.titleLabel?.font.pointSize)!)
        save.titleLabel?.adjustsFontSizeToFitWidth = true
        save.backgroundColor = UIColor.black
        save.setTitleColor(UIColor.white, for: .normal)
        save.addTarget(self, action: #selector(savePhoto), for: .touchDown)
        save.layer.shadowColor = UIColor.red.cgColor
        save.layer.shadowRadius = 5.0
        save.layer.shadowOpacity = 1.0
        save.layer.shadowOffset = CGSize(width: 0, height: 0)
        save.layer.masksToBounds = false
        self.view.addSubview(save)
        
        
        let botGrad = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        let topGrad = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height/2)
        gradientLayer.colors = [topGrad.cgColor, botGrad.cgColor]
        gradientLayer.zPosition = -2
        self.view.layer.addSublayer(gradientLayer)
        
        gradientLayer2.frame = CGRect(x: 0, y: screenSize.height/2, width: screenSize.width, height: screenSize.height/2)
        gradientLayer2.colors = [botGrad.cgColor, topGrad.cgColor]
        gradientLayer2.zPosition = -2
        self.view.layer.addSublayer(gradientLayer2)
        
        let knobSize = CGFloat(0.75)
        brightnessSlider = UISlider(frame:CGRect(x: 0, y: 0, width: screenSize.width*0.25*1/knobSize, height: screenSize.height/32))
        brightnessSlider.transform = CGAffineTransform(scaleX: knobSize, y: knobSize)
        brightnessSlider.center.x = screenSize.width*3/8
        brightnessSlider.center.y = screenSize.height - (screenSize.height - screenSize.width)*7/16
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 100
        brightnessSlider.isContinuous = true
        brightnessSlider.tintColor = UIColor.green
        brightnessSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
        self.view.addSubview(brightnessSlider)
        
        contrastSlider = UISlider(frame:CGRect(x: 0, y: 0, width: screenSize.width*0.25*1/knobSize, height: screenSize.height/32))
        contrastSlider.transform = CGAffineTransform(scaleX: knobSize, y: knobSize)
        contrastSlider.center.x = brightnessSlider.center.x
        contrastSlider.center.y = screenSize.height - (screenSize.height - screenSize.width)*5/16
        contrastSlider.minimumValue = 0
        contrastSlider.maximumValue = 100
        contrastSlider.isContinuous = true
        contrastSlider.tintColor = UIColor.green
        contrastSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
        self.view.addSubview(contrastSlider)
        
        saturationSlider = UISlider(frame:CGRect(x: 0, y: 0, width: screenSize.width*0.25*1/knobSize, height: screenSize.height/32))
        saturationSlider.transform = CGAffineTransform(scaleX: knobSize, y: knobSize)
        saturationSlider.center.x = contrastSlider.center.x
        saturationSlider.center.y = screenSize.height - (screenSize.height - screenSize.width)*3/16
        saturationSlider.minimumValue = 0
        saturationSlider.maximumValue = 100
        saturationSlider.isContinuous = true
        saturationSlider.tintColor = UIColor.green
        saturationSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
        self.view.addSubview(saturationSlider)
        
        noiseSlider = UISlider(frame:CGRect(x: 0, y: 0, width: screenSize.width*0.25*1/knobSize, height: screenSize.height/32))
        noiseSlider.transform = CGAffineTransform(scaleX: knobSize, y: knobSize)
        noiseSlider.center.x = saturationSlider.center.x
        noiseSlider.center.y = screenSize.height - (screenSize.height - screenSize.width)*1/16
        noiseSlider.minimumValue = 0
        noiseSlider.maximumValue = 100
        noiseSlider.isContinuous = true
        noiseSlider.tintColor = UIColor.green
        noiseSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
        self.view.addSubview(noiseSlider)
        
        brightLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.25*0.9, height: screenSize.height/32)
        brightLabel.center.x = screenSize.width*1/8
        brightLabel.center.y = brightnessSlider.center.y
        brightLabel.text = "Brightness"
        brightLabel.textAlignment = .left
        brightLabel.numberOfLines = 1
        brightLabel.font = UIFont(name: "impact", size: screenSize.height/40)
//        brightLabel.adjustsFontSizeToFitWidth = true
//        brightLabel.adjustsFontForContentSizeCategory = true
        brightLabel.textColor = UIColor.white
        brightLabel.layer.shadowColor = UIColor.white.cgColor
        brightLabel.layer.shadowRadius = 5.0
        brightLabel.layer.shadowOpacity = 1.0
        brightLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        brightLabel.layer.masksToBounds = false
        self.view.addSubview(brightLabel)
        
        contLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.25*0.9, height: screenSize.height/32)
        contLabel.center.x = screenSize.width*1/8
        contLabel.center.y = contrastSlider.center.y
        contLabel.text = "Contrast"
        contLabel.textAlignment = .left
        contLabel.numberOfLines = 1
        contLabel.font = UIFont(name: "impact", size: screenSize.height/40)
//        contLabel.adjustsFontSizeToFitWidth = true
//        contLabel.adjustsFontForContentSizeCategory = true
        contLabel.textColor = UIColor.white
        contLabel.layer.shadowColor = UIColor.white.cgColor
        contLabel.layer.shadowRadius = 5.0
        contLabel.layer.shadowOpacity = 1.0
        contLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        contLabel.layer.masksToBounds = false
        self.view.addSubview(contLabel)
        
        satLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.25*0.9, height: screenSize.height/32)
        satLabel.center.x = screenSize.width*1/8
        satLabel.center.y = saturationSlider.center.y
        satLabel.text = "Saturation"
        satLabel.textAlignment = .left
        satLabel.numberOfLines = 1
        satLabel.font = UIFont(name: "impact", size: screenSize.height/40)
//        satLabel.adjustsFontSizeToFitWidth = true
//        satLabel.adjustsFontForContentSizeCategory = true
        satLabel.textColor = UIColor.white
        satLabel.layer.shadowColor = UIColor.white.cgColor
        satLabel.layer.shadowRadius = 5.0
        satLabel.layer.shadowOpacity = 1.0
        satLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        satLabel.layer.masksToBounds = false
        self.view.addSubview(satLabel)
        
        noiseLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.25*0.9, height: screenSize.height/32)
        noiseLabel.center.x = screenSize.width*1/8
        noiseLabel.center.y = noiseSlider.center.y
        noiseLabel.text = "Noise"
        noiseLabel.textAlignment = .left
        noiseLabel.numberOfLines = 1
        noiseLabel.font = UIFont(name: "impact", size: screenSize.height/40)
//        noiseLabel.adjustsFontSizeToFitWidth = true
//        noiseLabel.adjustsFontForContentSizeCategory = true
        noiseLabel.textColor = UIColor.white
        noiseLabel.layer.shadowColor = UIColor.white.cgColor
        noiseLabel.layer.shadowRadius = 5.0
        noiseLabel.layer.shadowOpacity = 1.0
        noiseLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        noiseLabel.layer.masksToBounds = false
        self.view.addSubview(noiseLabel)
        
    }
    
    @objc func updateColors()
    {
        img.image = img.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        img.tintColor = UIColor.blue
        img.layer.zPosition = -1
    }
    
    // Start Editing The Text Field
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.textColor == darkBlack)
        {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        else if(textView.textColor == lightBlack)
        {
            textView.text = ""
            textView.textColor = UIColor.white
        }
        savedY = textView.center.y
        var dY = screenSize.height/2 - textView.center.y
        moveTextField(textView, moveDistance: Int(dY), up: true)
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        updateTextFont(topText)
        updateTextFont(botText)
        topText.textAlignment = .center
        botText.textAlignment = .center
    }
    
    // Finish Editing The Text Field
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(topText.text.trimmingCharacters(in: CharacterSet.newlines) == "" || topText.text == "TOP TEXT")
        {
            topText.text = "TOP TEXT"
            if(topText.textColor == UIColor.black)
            {
                topText.textColor = darkBlack
            }
            else if(topText.textColor == UIColor.white)
            {
                topText.textColor = lightBlack
            }
        }
        if(botText.text.trimmingCharacters(in: CharacterSet.newlines) == "" || botText.text == "BOTTOM TEXT")
        {
            botText.text = "BOTTOM TEXT"
            if(botText.textColor == UIColor.black)
            {
                botText.textColor = darkBlack
            }
            else if(botText.textColor == UIColor.white)
            {
                botText.textColor = lightBlack
            }
        }

        topText.text = topText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        botText.text = botText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        updateTextFont(topText)
        updateTextFont(botText)
        topText.textAlignment = .center
        botText.textAlignment = .center
        
        var dY = screenSize.height/2 - savedY
        moveTextField(textView, moveDistance: Int(dY), up: false)
    }
    
//    // Hide the keyboard when the return key pressed
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        textField.resignFirstResponder()
//        return true
//    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textView: UITextView, moveDistance: Int, up: Bool)
    {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        
        textView.center.y = textView.center.y + movement
        
        UIView.commitAnimations()
    }
    @objc func toggleColor(_ sender: UIButton)
    {
        if(sender.backgroundColor == UIColor.black)
        {
            sender.backgroundColor = UIColor.white
            sender.layer.borderColor = UIColor.black.cgColor
        }
        else
        {
            sender.backgroundColor = UIColor.black
            sender.layer.borderColor = UIColor.white.cgColor
        }
        topText.textColor = topColor.backgroundColor
        botText.textColor = botColor.backgroundColor
        
        if(topColor.backgroundColor == UIColor.black)
        {
            if(topText.text == nil || topText.text == "TOP TEXT")
            {
                topText.text = "TOP TEXT"
                topText.textColor = darkBlack
            }
            else
            {
                topText.textColor = UIColor.black
            }
            topText.layer.shadowColor = UIColor.white.cgColor
        }
        else
        {
            if(topText.text == nil || topText.text == "TOP TEXT")
            {
                topText.text = "TOP TEXT"
                topText.textColor = lightBlack
            }
            else
            {
                topText.textColor = UIColor.white
            }
            topText.layer.shadowColor = UIColor.black.cgColor
        }
        if(botColor.backgroundColor == UIColor.black)
        {
            if(botText.text == nil || botText.text == "BOTTOM TEXT")
            {
                botText.text = "BOTTOM TEXT"
                botText.textColor = darkBlack
            }
            else
            {
                botText.textColor = UIColor.black
            }
            botText.layer.shadowColor = UIColor.white.cgColor
        }
        else
        {
            if(botText.text == nil || botText.text == "BOTTOM TEXT")
            {
                botText.text = "BOTTOM TEXT"
                botText.textColor = lightBlack
            }
            else
            {
                botText.textColor = UIColor.white
            }
            botText.layer.shadowColor = UIColor.black.cgColor
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed
        {
            if(topText.frame.contains(gestureRecognizer.location(in: self.view)))
            {
                let translation = gestureRecognizer.translation(in: self.view)
                topText.center = CGPoint(x: topText.center.x + translation.x, y: topText.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            else if(botText.frame.contains(gestureRecognizer.location(in: self.view)))
            {
                let translation = gestureRecognizer.translation(in: self.view)
                botText.center = CGPoint(x: botText.center.x + translation.x, y: botText.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        }
    }
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer)
    {
        if(topText.frame.contains(pinch.location(in: self.view)))
        {
            topText.transform = topText.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
        else if(botText.frame.contains(pinch.location(in: self.view)))
        {
            botText.transform = botText.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer)
    {
        if(topText.frame.contains(recognizer.location(in: self.view)))
        {
            topText.transform = topText.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
        else if(botText.frame.contains(recognizer.location(in: self.view)))
        {
            botText.transform = botText.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    
    @objc func onClickPickImage(_ sender: Any)
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func savePhoto(_ sender: AnyObject)
    {
        gradientLayer.isHidden = true
        gradientLayer2.isHidden = true
        
        if(img.image != nil)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
            let context = UIGraphicsGetCurrentContext()
            self.view.layer.render(in: context!)
            let screenShot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            var saveImage = UIImage()
            saveImage = cropToBounds(image: screenShot!, width: Double(img.frame.width), height: Double(img.frame.height))
            UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil)

            let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        gradientLayer.isHidden = false
        gradientLayer2.isHidden = false
    }
    @objc func copyImage(_ sender: AnyObject)
    {
        gradientLayer.isHidden = true
        gradientLayer2.isHidden = true
        if(img.image != nil)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
            let context = UIGraphicsGetCurrentContext()
            self.view.layer.render(in: context!)
            let screenShot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            var saveImage = UIImage()
            saveImage = cropToBounds(image: screenShot!, width: Double(img.frame.width), height: Double(img.frame.height))
            UIPasteboard.general.image = saveImage
            //UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil)
            
            let alert = UIAlertController(title: "Copied", message: "Your image has been copied", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        gradientLayer.isHidden = false
        gradientLayer2.isHidden = false
    }
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage
    {
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if height > width
        {
            // Good
            cgwidth = contextSize.width*CGFloat(width/height)
            cgheight = contextSize.width//*CGFloat(height/width)
            
            //
            posX = (CGFloat(cgimage.width) - cgwidth)/2//((contextSize.width - contextSize.width*CGFloat(width/height)) / 2)
            posY = (CGFloat(cgimage.height) - cgheight)/2//((contextSize.height - contextSize.width*CGFloat(height/width)) / 2)
            
            print("bigheight")
        }
        else
        {
            // Good
            cgwidth = contextSize.width
            cgheight = contextSize.width*CGFloat(height/width)
            print("bigwidth")
            
            // Good
            posX = (CGFloat(cgimage.width) - cgwidth)/2//0
            posY = (CGFloat(cgimage.height) - cgheight)/2//((contextSize.height - contextSize.width*CGFloat(height/width)) / 2)
        }
        
        let rect: CGRect = CGRect(x: posX + 1, y: posY + 1, width: cgwidth-2, height: cgheight-2)
        
        print("screenWidth: \(screenSize.width)")
        print("screenHeight: \(screenSize.height)")
        print("xpos: \(posX)")
        print("ypos: \(posY)")
        print("width: \(rect.width)")
        print("height: \(rect.height)")
        print("imgWidth: \(cgimage.width)")
        print("imgHeight: \(cgimage.height)")
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: 0.0, orientation: image.imageOrientation)
        
        return image
    }

    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            if(image.size.width > image.size.height)
            {
                img.frame = CGRect(x: 0, y: 0, width: image.size.width/image.size.width*screenSize.width, height: image.size.height/image.size.width*screenSize.width)
            }
            else
            {
                img.frame = CGRect(x: 0, y: 0, width: image.size.width/image.size.height*screenSize.width, height: image.size.height/image.size.height*screenSize.width)
            }
            img.center.y = screenSize.height/2
            img.image = image
            img.center.x = screenSize.width/2
            img.center.y = screenSize.height/2
            img.layer.borderWidth = 0.0
        }
        
        dismiss(animated: true, completion: nil)
       
        topText.frame = CGRect(x: 0, y: 0, width: img.frame.width*0.9, height: screenSize.width/4)
        topText.center.y = img.frame.minY + topText.frame.height/2
        topText.center.x = screenSize.width/2
        updateTextFont(topText)
        
        botText.frame = CGRect(x: 0, y: 0, width: img.frame.width*0.9, height: screenSize.width/4)
        botText.center.y = img.frame.maxY - botText.frame.height/2
        botText.center.x = screenSize.width/2
        updateTextFont(botText)
    }
}
func updateTextFont(_ textView: UITextView)
{
    if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize(width: 0, height: 0)))
    {
        return;
    }
    let textViewSize = textView.frame.size;
    let fixedWidth = textViewSize.width;
    let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));
    
    var expectFont = textView.font;
    if (expectSize.height > textViewSize.height)
    {
        while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height)
        {
            expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
            textView.font = expectFont
        }
    }
    else
    {
        while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height)
        {
            expectFont = textView.font;
            textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
        }
        textView.font = expectFont;
    }
//    textView.sizeToFit()
//    textView.centerVertically()
}
// Put this piece of code anywhere you like
extension UIViewController
{
    func hideKeyboardWhenTappedAround(_ topView: UITextView, _ botView: UITextView)
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
extension UITextView
{
    func centerVertically()
    {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.infinity)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
