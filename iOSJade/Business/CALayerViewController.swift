//
//  CALayerViewController.swift
//  iOSJade
//
//  Created by goingta on 2019/5/27.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit

class CALayerViewContoller: UIViewController {
    
    let slider = UISlider(frame: CGRect.zero)
    
    let layerOne = ProgressLineLayer()
    let layerTwo = ProgressFillLayer()
    let layerThree = ProgressLinePathLayer()
    let layerFour = ProgressWaterFillLayer()
    
    
    let drawLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        view.layer.addSublayer(layerOne)
        view.layer.addSublayer(layerTwo)
        view.layer.addSublayer(layerThree)
        view.layer.addSublayer(layerFour)
        
        layerOne.number = 0.0
        layerTwo.number = 0.0
        layerThree.number = 0.0
        layerFour.number = 0.0

        //1. 创建calayer
//        drawLayer.borderColor = UIColor.cyan.cgColor
//        drawLayer.borderWidth = 5
//        drawLayer.delegate = self
//        self.view.layer.addSublayer(drawLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let wh = view.frame.width - 44
        drawLayer.frame = CGRect(x: 20, y: 150, width: wh, height: wh)
        
        self.slider.frame = CGRect(x: 50, y: 170, width: self.view.frame.size.width - 100.0, height: 30)
        
        let lWH = 100
        let horSpace = (320 - 2*lWH) / 3
        
        layerOne.frame = CGRect(x: horSpace, y: 210, width: lWH, height: lWH)
        layerTwo.frame = CGRect(x: horSpace*2+lWH, y: 210, width: lWH, height: lWH)
        layerThree.frame = CGRect(x: horSpace, y: 210+lWH+30, width: lWH, height: lWH)
        layerFour.frame = CGRect(x: horSpace*2+lWH, y: 210+lWH+30, width: lWH, height: lWH)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //2.调用layer的setNeedsDisplay 进行绘制
        drawLayer.setNeedsDisplay()
    }
    
    
    @objc func sliderValueChanged() {
        layerOne.number = Double(slider.value)
        layerTwo.number = Double(slider.value)
        layerThree.number = Double(slider.value)
        layerFour.number = Double(slider.value)
    }
}

extension CALayerViewContoller: CALayerDelegate {
    //3.实现代理方法，画图
    func draw(_ layer: CALayer, in ctx: CGContext) {
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setLineWidth(2.0)
        ctx.addEllipse(in: CGRect(x: 10, y: 10, width: 50, height: 50))
        ctx.strokePath()
    }
}

class ALayer: CALayer {
    override func draw(in ctx: CGContext) {
        ctx.setFillColor(UIColor.red.cgColor)//画笔颜色(填充)
        ctx.addEllipse(in: CGRect(x: 10, y: 10, width: 50, height: 50))
        ctx.fillPath()
    }
}

class ProgressLayer: CALayer {
    var number : Double = 0.0 {
        didSet {
            self.tLayer.string = String(format: "%0.1f%%", number*100)
            self.tLayer.setNeedsDisplay()
            self.setNeedsDisplay()
        }
    }
    let tLayer: CATextLayer = {
        let text = CATextLayer()
        let font = UIFont.systemFont(ofSize: 12)
        text.font = font.fontName as CFTypeRef
        text.fontSize = font.pointSize
        text.foregroundColor = UIColor.black.cgColor
        text.alignmentMode = CATextLayerAlignmentMode.center
        text.contentsScale = UIScreen.main.scale
        text.isWrapped = true
        text.string = ""
        return text
    }()
    
    override init() {
        super.init()
        self.addSublayer(tLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        let tH = NSString(string: "100%").boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], context: nil).height
        tLayer.frame = CGRect(x: 0, y: self.frame.height*0.5 - tH*0.5, width: self.frame.width, height: tH)
    }
}


class ProgressLineLayer: ProgressLayer{
    override func draw(in ctx: CGContext) {
        
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width*0.5, y: self.frame.height*0.5)
        let endAngle = CGFloat(self.number) * CGFloat.pi * 2.0 - CGFloat.pi * 0.5
        
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setLineWidth(radius*0.08)
        ctx.setLineCap(CGLineCap.round)
        
        ctx.addArc(center: center, radius: radius, startAngle: -0.5*CGFloat.pi, endAngle: endAngle, clockwise: false)
        
        ctx.strokePath()
    }
}

class ProgressFillLayer: ProgressLayer {
    override func draw(in ctx: CGContext) {
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width*0.5, y: self.frame.height*0.5)
        let endAngle = CGFloat(self.number) * CGFloat.pi * 2.0 - CGFloat.pi * 0.5
        
        ctx.setFillColor(UIColor.yellow.cgColor)
        
        ctx.move(to: center)
        ctx.addLine(to: CGPoint(x: center.x, y: self.frame.height*0.05))
        ctx.addArc(center: center, radius: radius, startAngle: -0.5*CGFloat.pi, endAngle: endAngle, clockwise: false)
        ctx.closePath()
        
        ctx.fillPath()
    }
}

class ProgressLinePathLayer: ProgressLayer{
    override func draw(in ctx: CGContext) {
        
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width*0.5, y: self.frame.height*0.5)
        let endAngle = CGFloat(self.number) * CGFloat.pi * 2.0 - CGFloat.pi * 0.5
        
        ctx.setStrokeColor(UIColor.gray.withAlphaComponent(0.8).cgColor)
        ctx.setLineWidth(radius*0.07)
        ctx.addEllipse(in: CGRect(x: self.frame.width*0.05, y: self.frame.height*0.05, width: self.frame.width*0.9, height: self.frame.height*0.9))
        ctx.strokePath()
        
        ctx.setStrokeColor(UIColor.blue.cgColor)
        ctx.setLineWidth(radius*0.08)
        ctx.setLineCap(CGLineCap.round)
        
        ctx.addArc(center: center, radius: radius, startAngle: -0.5*CGFloat.pi, endAngle: endAngle, clockwise: false)

        ctx.strokePath()
    }
}

class ProgressWaterFillLayer: ProgressLayer {
    override func draw(in ctx: CGContext) {
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width*0.5, y: self.frame.height*0.5)
        let startAngle = CGFloat.pi * 0.5 - CGFloat(self.number) * CGFloat.pi
        let endAngle = CGFloat.pi * 0.5 + CGFloat(self.number) * CGFloat.pi
        
        ctx.setStrokeColor(UIColor.gray.withAlphaComponent(0.3).cgColor)
        ctx.setLineWidth(radius*0.07)
        ctx.addEllipse(in: CGRect(x: self.frame.width*0.05, y: self.frame.height*0.05, width: self.frame.width*0.9, height: self.frame.height*0.9))
        ctx.strokePath()
        
        ctx.setFillColor(UIColor.yellow.cgColor)
        
        ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx.closePath()
        
        ctx.fillPath()
    }
}
