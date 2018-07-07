//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Modified by Seth Mosgin
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    //UIPickerView delegate methods
    //How many columns are in the PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //How many rows are in the PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //Place appropriate titles for each row in the PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //What happens when a user selects a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        
        getCurrencyData(url: finalURL)
    }

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getCurrencyData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the currency data")
                    let currencyJSON : JSON = JSON(response.result.value!)
//                    print(currencyJSON)
                    self.updateCurrencyData(json: currencyJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateCurrencyData(json : JSON) {

        if let result = json["averages"]["day"].double {
            bitcoinPriceLabel.text = String(result)
        } else {
            bitcoinPriceLabel.text = "Currency unavailable"
        }
    }
    




}

