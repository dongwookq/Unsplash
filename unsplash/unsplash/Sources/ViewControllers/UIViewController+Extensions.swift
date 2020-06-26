//
//  UIViewController+Alert.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

extension UIViewController {

    func showErrorAlert(error: Error, viewController: UIViewController) {
      let alertController = UIAlertController(title: "⚠️", message: error.localizedDescription, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      viewController.present(alertController, animated: true, completion: nil)
    }

}
