//
//  ViewController.swift
//  AITellingUFortune
//
//  Created by Jason Hsu on 2018/7/24.
//  Copyright © 2018 junchoon. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendMassage(_ sender: UIButton) {
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        //請求發送到API.AI並清除textfield中的文字
        ApiAI.shared().enqueue(request)
        messageField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.responseLabel.text = text
        }, completion: nil)

}

