//
//  puzzleVC.swift
//  BlindfoldChessPuzzles
//
//  Created by Marty McCluskey on 12/9/19.
//  Copyright © 2019 Marty McCluskey. All rights reserved.
//

import UIKit
import AVFoundation

class puzzleVC: UIViewController {
    
    var audioFileSound: AVAudioPlayer?
    var pInfo: puzzleInfo?

    @IBOutlet weak var numTurnsLabel: UILabel!
    @IBOutlet weak var playerMoveLabel: UILabel!
    @IBOutlet weak var boardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numTurnsLabel.text = pInfo!.numTurns!
        self.playerMoveLabel.text = pInfo!.playerMove!
        
        print(self.pInfo!.folderPath!)

    }
    
    //plays the moves audio file
    @IBAction func playMovesPress(_ sender: Any) {
        if let pDir = self.pInfo!.folderPath {
            let pMovesPath = Bundle.main.path(forResource: "puzzleMoves", ofType: ".mp3", inDirectory: pDir )
            let url = URL(fileURLWithPath: pMovesPath!)
            
            do {
                audioFileSound = try AVAudioPlayer(contentsOf: url)
                audioFileSound?.play()
            } catch {
                print("couldn't play sound")
            }
        }

    }
    
    //plays the puzzle solution audio file
    @IBAction func playSolutionPress(_ sender: Any) {
        if let pDir = self.pInfo!.folderPath {
            let pSolPath = Bundle.main.path(forResource: "puzzleSolution", ofType: ".mp3", inDirectory: pDir )
            let url = URL(fileURLWithPath: pSolPath!)
            
            do {
                audioFileSound = try AVAudioPlayer(contentsOf: url)
                audioFileSound?.play()
            } catch {
                print("couldn't play sound")
            }
        }
    }
    
    // set boardLabel background as puzzle.pdf
    @IBAction func showPuzzlePress(_ sender: Any) {
        if let pDir = self.pInfo!.folderPath {
            if let puzzImagePath = Bundle.main.path(forResource: "puzzle", ofType: ".pdf", inDirectory: pDir ){
                let puzzImage = UIImage(contentsOfFile: puzzImagePath)
                self.boardLabel.backgroundColor = UIColor(patternImage: puzzImage!)
            }
        }
    }
    
    // set boardLabel background as solution.pdf
    @IBAction func showSolutionPress(_ sender: Any) {
        if let pDir = self.pInfo!.folderPath {
            if let solImagePath = Bundle.main.path(forResource: "solution", ofType: ".pdf", inDirectory: pDir ){
                    let solImage = UIImage(contentsOfFile: solImagePath)
                    self.boardLabel.backgroundColor = UIColor(patternImage: solImage!)
            }
        }
    }
    
   

}
