//
//  ResultsViewController.swift
//  RockPaperScissors
//
//  Created by Dunning Nicholas, EV-44 on 26.02.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

// The enum "Shape" represents a play or move
enum Shape: String {
    case Rock = "Rock"
    case Paper = "Paper"
    case Scissors = "Scissors"

    // This function randomly generates an opponent's play
    static func randomShape() -> Shape {
        let shapes = ["Rock", "Paper", "Scissors"]
        let randomChoice = Int(arc4random_uniform(3))
        return Shape(rawValue: shapes[randomChoice])!
    }
}

class ResultsViewController: UIViewController {

    @IBOutlet weak var gameResultLabel: UILabel!
    @IBOutlet weak var gameResultImage: UIImageView!
    
    var userChoice: Shape!
    private let opponentChoice: Shape = Shape.randomShape()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayResult()
    }

    private func displayResult() {
        // Ideally, most of this would be handled by a model.
        var imageName: String
        var text: String
        let matchup = "\(userChoice.rawValue) vs. \(opponentChoice.rawValue)"

        // Why is an exclamation point necessary? :)
        switch (userChoice!, opponentChoice) {
        case let (user, opponent) where user == opponent:
            text = "\(matchup): it's a tie!"
            imageName = "tie"
        case (.Rock, .Scissors), (.Paper, .Rock), (.Scissors, .Paper):
            text = "You win with \(matchup)!"
            imageName = "\(userChoice.rawValue)-\(opponentChoice.rawValue)"
        default:
            text = "You lose with \(matchup) :(."
            imageName = "\(opponentChoice.rawValue)-\(userChoice.rawValue)"
        }

        imageName = imageName.lowercased()
        gameResultImage.image = UIImage(named: imageName)
        gameResultLabel.text = text
    }
    
    @IBAction func playAgain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func viewHistory(_ sender: Any) {
        performSegue(withIdentifier: "history", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history" {
            let vc = segue.destination as! HistoryViewController
            vc.gameHistory.append(gameResultLabel.text ?? "ERROR")
        }
    }
}
