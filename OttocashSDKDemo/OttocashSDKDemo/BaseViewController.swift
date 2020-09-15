//
//  BaseViewController.swift
//  ottocashsdktest
//
//  Created by Clapping Ape on 08/09/19.
//  Copyright © 2019 Clapping Ape. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var mainScrollView : UIScrollView? = nil
    var tap : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func addPaddingOnTextField(textField: UITextField){
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 40))
        textField.leftView = paddingView1
        textField.leftViewMode = .always
        
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 40))
        textField.rightView = paddingView2
        textField.rightViewMode = .always
    }
    
    func add(asChildViewController viewController: UIViewController, container: UIView!) {
        self.addChild(viewController)
        container.addSubview(viewController.view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: container.frame.height)
        viewController.view.clipsToBounds = true
        
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    // MARK: - Alert View
    func basicAlertView(title: String, message: String, successBlock: (() -> Swift.Void)? = nil, retryFunction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if retryFunction != nil{
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: {
                (alert: UIAlertAction!) in
                retryFunction?()
            }
            ))
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            (alert: UIAlertAction!) in
            successBlock?()
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension BaseViewController{
    // MARK: Keyboard Control
    func registerKeyboardNotification(scrollView: UIScrollView) {
        self.mainScrollView = scrollView
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self as? UIGestureRecognizerDelegate
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.mainScrollView == nil {
            return
        }
        
        //Need to calculate keyboard exact size due to Apple suggestions
        self.mainScrollView?.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.mainScrollView?.contentInset = contentInsets
        self.mainScrollView?.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if self.mainScrollView?.getSelectedTextField() != nil
        {
            let textField = self.mainScrollView?.getSelectedTextField()
            var resultFrame = CGRect.zero
            resultFrame = self.mainScrollView?.convert((textField?.frame)!, from: textField?.superview) ?? CGRect.zero
            
            if (!aRect.contains(resultFrame))
            {
                self.mainScrollView?.scrollRectToVisible(resultFrame, animated: true)
            }
        }
        else if self.mainScrollView?.getSelectedTextView() != nil
        {
            let textView = self.mainScrollView?.getSelectedTextView()
            var resultFrame = CGRect.zero
            resultFrame = self.mainScrollView?.convert((textView?.frame)!, from: textView?.superview) ?? CGRect.zero
            
            if (!aRect.contains(resultFrame))
            {
                self.mainScrollView?.scrollRectToVisible(resultFrame, animated: true)
            }
        }
        
        
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.mainScrollView?.contentInset = contentInset
        self.view.removeGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
}

extension UIView {
    func getSelectedTextField() -> UITextField? {
        
        let totalTextFields = getTextFieldsInView(view: self)
        
        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }
        
        return nil
        
    }
    
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        
        var totalTextFields = [UITextField]()
        
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        
        return totalTextFields
    }
    
    func getSelectedTextView() -> UITextView? {
        
        let totalTextViews = getTextViewsInView(view: self)
        
        for TextView in totalTextViews{
            if TextView.isFirstResponder{
                return TextView
            }
        }
        
        return nil
        
    }
    
    func getTextViewsInView(view: UIView) -> [UITextView] {
        
        var totalTextViews = [UITextView]()
        
        for subview in view.subviews as [UIView] {
            if let TextView = subview as? UITextView {
                totalTextViews += [TextView]
            } else {
                totalTextViews += getTextViewsInView(view: subview)
            }
        }
        
        return totalTextViews
    }
}



