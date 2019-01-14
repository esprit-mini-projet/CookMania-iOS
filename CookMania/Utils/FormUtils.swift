//
//  FormUtils.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/25/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class FormUtils {
    public static func validateEmail(email: String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailText = NSPredicate(format:"SELF MATCHES [c]%@",emailRegex)
        return (emailText.evaluate(with: email))
    }
}
