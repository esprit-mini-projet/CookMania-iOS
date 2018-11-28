//
//  AddIngredientView.swift
//  CookMania
//
//  Created by Elyes on 11/27/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import iOSDropDown

class AddIngredientView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var quantityView: UITextField!
    @IBOutlet var unitView: DropDown!
    @IBOutlet var ingredientView: UITextField!
    @IBOutlet var deleteButton: UIButton!

    
    let XIB_NAME = "AddIngredientView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
