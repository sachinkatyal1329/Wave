//
//  FileWriter.swift
//  Wave
//
//  Created by Sachin Katyal on 6/13/18.
//  Copyright © 2018 Sachin Katyal. All rights reserved.
//

import Foundation
import SpriteKit

class FileWriter {
    
    var highScore: CGFloat!
    
    init() {
        
    }
    
    
    
    func write(text: String) {
        print("method called")
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent("data.txt")
                
                // define the string/text to be saved
                // writing to disk
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print("saving was successful")
                // any code posterior code goes here
                // reading from disk
                let savedText = try String(contentsOf: fileURL)
                print("savedText:", savedText)
                
                self.highScore = CGFloat(Double(savedText)!)
                
            }
        } catch {
            print("error:", error)
        }
    }
        
    func write(data: CGFloat) {
        let text = "\(data)"
        write(text: text)
        
    }
    
    func write(text: String, to fileNamed: String) {

    }
    
    func read() -> CGFloat{
        

        do {
            

            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                
                let fileURL = documentDirectory.appendingPathComponent("data.txt")
                
                // any code posterior code goes here
                // reading from disk
                let savedText = try String(contentsOf: fileURL)
                //print("savedText:", savedText)
                
                //print(savedText)
                
                self.highScore = CGFloat(Double(savedText)!)
                //print(highScore)
                return highScore
                
            }
        } catch {
            print("error:", error)
        }
        
        return 0

    }
    
}
