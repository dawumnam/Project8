//
//  ViewController.swift
//  Project8
//
//  Created by dawum nam on 5/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var correntAnswer = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "CLUES"
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.addTarget(self, action: #selector(submitTapped), for:  .touchUpInside)
        submit.setTitle("Submit", for: .normal)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.addTarget(self, action: #selector(clearTapped), for:  .touchUpInside)
        clear.setTitle("Clear", for: .normal)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for:  .touchUpInside)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)
              
                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.gray.cgColor
//        buttonsView.backgroundColor = .green
//        cluesLabel.backgroundColor = .red
//        answersLabel.backgroundColor = .blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(loadLevel), with: nil)
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            var clueString = cluesLabel.text?.components(separatedBy: "\n")
            clueString?[solutionPosition] = "\(solutionPosition + 1)."
            cluesLabel.text = clueString?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            correntAnswer += 1
            if correntAnswer % 7 == 0 {
                let ac = UIAlertController(title: "You Passed", message: "Congratulations, Proceed to the next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Wrong!", message: "", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true) {
                self.currentAnswer.text = ""
                for button in self.activatedButtons {
                    button.isHidden = false
                }
                self.activatedButtons.removeAll()
                self.score -= 1
            }
        }
        
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        correntAnswer = 0
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    @objc func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURl) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index+1). \(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.letterButtons.shuffle()
            
            if self?.letterButtons.count == letterBits.count {
                for i in 0..<self!.letterButtons.count {
                    self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
        
    }


}

