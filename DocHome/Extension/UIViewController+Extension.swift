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
    
    func changeStatusBarBgColor(bgColor: UIColor? = .white) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
            
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = bgColor
            
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
}
