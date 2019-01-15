//
//  Loader.swift
//  CookMania
//
//  Created by Seif Abdennadher on 1/15/19.
//  Copyright © 2019 MiniProjet. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Loader {
    
    private static var instance: Loader?
    private var loaders: Int = 0
    
    private init() {}
    
    public static func getInstance() -> Loader{
        if(instance == nil){
            instance = Loader()
        }
        return instance!
    }
    
    func startLoader() {
        if loaders == 0 {
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        }
        loaders+=1
    }
    
    func stopLoader() {
        if loaders > 0 {
            loaders-=1
            if loaders == 0 {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            }
        }
    }

}
