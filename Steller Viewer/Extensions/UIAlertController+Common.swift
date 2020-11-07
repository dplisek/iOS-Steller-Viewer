//
//  UIAlertController+Defaults.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import UIKit

extension UIAlertController {
    static func presentSimpleAlert(on vc: UIViewController?, title: String?, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "general.ok".localized,
            style: .default,
            handler: { _ in alert.dismiss(animated: true) }
        ))
        vc?.present(alert, animated: true)
    }
}
