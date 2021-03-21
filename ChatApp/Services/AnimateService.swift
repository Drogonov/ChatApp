//
//  AnimateService.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//
import UIKit

protocol AnimateServiceDelegate {
    func animateExpand(shouldExpand: Bool, completion: @escaping(Bool) -> Void)
}

class AnimateService: AnimateServiceDelegate {
    func animateExpand(shouldExpand: Bool, completion: @escaping(Bool) -> Void) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            }, completion: completion)
        }
    }
}
