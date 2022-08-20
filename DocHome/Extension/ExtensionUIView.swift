//
//  TabEndEditing.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/21.
//

import Foundation

extension UIView {
    func tabEndEditing() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(tabEndEditingAction(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tabEndEditingAction(_ sender: Any) {
        self.endEditing(true)
    }
}
