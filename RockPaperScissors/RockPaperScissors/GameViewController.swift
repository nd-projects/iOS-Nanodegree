//
//  ViewController.swift
//  RockPaperScissors
//
//  Created by Dunning Nicholas, EV-44 on 26.02.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBAction private func playRock(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        viewController.userChoice = getUserShape(sender)
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction private func playPaper(_ sender: UIButton) {
        performSegue(withIdentifier: "play", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play" {
            let vc = segue.destination as! ResultsViewController
            vc.userChoice = getUserShape(sender as! UIButton)
        }
    }
    
    private func getUserShape(_ sender: UIButton) -> Shape {
        // Titles are set to one of: Rock, Paper, or Scissors
        let shape = sender.title(for: UIControl.State())!
        return Shape(rawValue: shape)!
    }
}

