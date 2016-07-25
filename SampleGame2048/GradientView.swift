//
//  GradientView.swift
//  SampleGame2048
//
//  Created by HuuLuong on 7/22/16.
//  Copyright © 2016 CanhDang. All rights reserved.
//

import UIKit

class GradientView: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createGradient()
    }
    
    func createGradient() {
        let bgGradient = CAGradientLayer()
        
        bgGradient.frame = self.frame
        
        bgGradient.colors = [UIColor.init(red: 120/255, green: 100/255, blue: 150/255, alpha: 1.0).CGColor ,UIColor.init(red: 150/255, green: 200/255, blue: 160/255, alpha: 1.0).CGColor]
        
        let startPoint = CGPoint.init(x: 0.3, y: 0.3)
        let endPoint = CGPoint.init(x: 0.8, y: 0.8)
        
        bgGradient.startPoint = startPoint
        bgGradient.endPoint = endPoint
        
        self.layer.insertSublayer(bgGradient, atIndex: 0)
        
    }
}
