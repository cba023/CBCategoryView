//
//  ViewController.swift
//  Demo0828
//
//  Created by jenkins on 2020/8/28.
//  Copyright © 2020 jenkins. All rights reserved.
//

import UIKit
@_exported import SnapKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let cates: [(String, String)] = [("全部0", ""), ("点击最多1", ""), ("经典2", ""), ("怀旧3", ""), ("流行4", ""), ("最新5", ""), ("80后6", ""), ("90后7", ""), ("00后8", ""), ("最受欢迎9", ""),  ("流行10", ""), ("最新11", ""), ("80后12", ""), ("90后13", ""), ("00后14", ""), ("最受欢迎15", ""), ]
    lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var cateScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    var cateBtns: [UIButton] = []
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = .white
        view.addSubview(cateScrollView)
        view.addSubview(contentScrollView)
        
        cateScrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(cateScrollView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        view.layoutIfNeeded()
        configContent()
    }
    
    func configContent() {
        
        let count = cates.count
        
        let anchorPadding: CGFloat = 10.0
        
        var anchorX: CGFloat = anchorPadding
        
        self.cateBtns = []
        
        for i in 0..<count {
            
            let title = cates[i].0
            let btn = UIButton()
            cateScrollView.addSubview(btn)
            self.cateBtns.append(btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(.darkGray, for: .normal)
            btn.setTitleColor(.red, for: .selected)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.sizeToFit()
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(cateButtonClick(sender:)), for: .touchUpInside)
            
            let curItemWidth: CGFloat =  btn.titleLabel!.bounds.width + 15
            
            btn.snp.makeConstraints { (make) in
                make.leading.equalTo(anchorX)
                make.top.equalToSuperview()
                make.height.equalTo(self.cateScrollView.snp.height).offset(-2)
                make.width.equalTo(curItemWidth)
                if i == count - 1 {
                    make.right.equalToSuperview().offset(-anchorPadding)
                }
                anchorX += curItemWidth
            }
            
            let backView: UIView = UIView()
            contentScrollView.addSubview(backView)
            let lbl = UILabel()
            lbl.text = "\(i)"
            backView.addSubview(lbl)
            lbl.snp.makeConstraints { (make) in
                make.center.equalTo(backView)
            }
            backView.snp.makeConstraints { (make) in
                make.leading.equalTo(self.contentScrollView.bounds.width * CGFloat(i))
                make.top.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(self.contentScrollView.bounds.width)
                if i == count - 1 {
                    make.right.equalToSuperview()
                }
            }
            if i % 2 == 0 {
                backView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
            } else {
                backView.backgroundColor = UIColor.init(white: 0.85, alpha: 1)
            }
    
        }
        
        if let firstBtn = self.cateBtns.first {
            firstBtn.isSelected = true
            cateScrollView.addSubview(indicator)
            remakeIndicatorConstrainsTo(btn: firstBtn)
        }
    }
    
    @objc func cateButtonClick(sender: UIButton) {
        let index = sender.tag - 100
//        print(index)
        let btn = cateBtns[index]
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2, animations: {
            self.remakeIndicatorConstrainsTo(btn: btn)
            self.view.layoutIfNeeded()
            let cateScrollViewWidth = self.cateScrollView.bounds.width
            let cateScrollViewContentWidth = self.cateScrollView.contentSize.width
            let x = btn.frame.midX
            if x > cateScrollViewWidth / 2.0 {
                if x < cateScrollViewContentWidth - cateScrollViewWidth / 2.0 {
                    self.cateScrollView.setContentOffset(CGPoint(x: x - self.cateScrollView.bounds.width / 2.0, y: 0), animated: true)
                } else {
                    self.cateScrollView.setContentOffset(CGPoint(x: cateScrollViewContentWidth - self.cateScrollView.bounds.width, y: 0), animated: true)
                }
            } else {
                self.cateScrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }) { (finished) in
            
            
        }
        
    }
    
    
    func remakeIndicatorConstrainsTo(btn: UIButton) {
        cateBtns.forEach { (b) in
            b.isSelected = b == btn
        }
        indicator.snp.remakeConstraints { (make) in
            make.width.equalTo(btn.snp.width).offset(4)
            make.centerX.equalTo(btn.snp.centerX)
            make.height.equalTo(2)
            make.top.equalTo(btn.snp.bottom)
        }
        currentPage = btn.tag - 100
        self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * contentScrollView.bounds.width, y: 0), animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            let offsetX = scrollView.contentOffset.x

            let curPage: Int = Int((offsetX + contentScrollView.bounds.width / 2.0) / contentScrollView.bounds.width)
            if currentPage != curPage {
                currentPage = curPage
                self.cateButtonClick(sender: self.cateBtns[curPage])
            }
//            print("CurPage:", curPage)
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("currentPage:", currentPage)
    }
    
}

