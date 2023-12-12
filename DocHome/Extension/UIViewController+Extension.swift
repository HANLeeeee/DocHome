//
//  UIViewController+Extension.swift
//  DocHome
//
//  Created by 최하늘 on 12/12/23.
//

import Foundation

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "알림", message: "알림메시지", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "확인", style: .default)
        alert.addAction(cancle)
        
        self.present(alert, animated: true)
    }
}
