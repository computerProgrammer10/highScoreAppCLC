//
//  AppData.swift
//  foreverGameCLCApp
//
//  Created by DANIEL HUSEBY on 2/28/25.
//

import Foundation

class AppData{
    
    
    static var curSave = Save()
    static var defaults = UserDefaults.standard
    static var decoder = JSONDecoder()
    
    
    
    static func saveData(){
        if let encoded = try? JSONEncoder().encode(curSave){
             defaults.set(encoded, forKey: "Save")
         }
    }
    static func isData() -> Bool{
        if let save = defaults.data(forKey: "Save"){
            if let decoded = try? decoder.decode(Save.self, from: save){
                AppData.curSave = decoded
                return true
            }
        }
        return false
    }
}
