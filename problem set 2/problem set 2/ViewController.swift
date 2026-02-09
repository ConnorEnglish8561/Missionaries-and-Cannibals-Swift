//
//  ViewController.swift
//  problem set 2
//
//  Created by English, Connor on 2/7/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var missionariesSelected = 0
    var cannibalsSelected = 0
    var inBoat = 0
    
    var mOnLeft = 3
    var cOnLeft = 3
    var charactersOnLeft = 6
    var mOnRight = 0
    var cOnRight = 0
    var charactersOnRight = 0
    
    var boatOnLeft = true
    
    let mLabel = UILabel()
    let cLabel = UILabel()
    let bLabel = UILabel()
    let blLabel = UILabel()
    let wlLabel = UILabel()
    
    let crossButton = UIButton()
    let resetButton = UIButton()
    
    let bigStackView = UIStackView()
    let leftStackView = UIStackView()
    let middleStackView = UIStackView()
    let rightStackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bigStackView)
        bigStackView.addArrangedSubview(leftStackView)
        bigStackView.addArrangedSubview(middleStackView)
        bigStackView.addArrangedSubview(rightStackView)
        
        let topInterfaceView = UIStackView()
        view.addSubview(topInterfaceView)
        
        let bottomInterfaceView = UIStackView()
        view.addSubview(bottomInterfaceView)
        
     
        bigStackView.snp.makeConstraints{
            $0.top.equalTo(topInterfaceView.snp.bottom)
            $0.bottom.equalTo(bottomInterfaceView.snp.top)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        topInterfaceView.snp.makeConstraints{
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(150)
            
        }
        
        bottomInterfaceView.snp.makeConstraints {
            $0.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(150)
        }
        
        topInterfaceView.axis = .vertical
        topInterfaceView.distribution = .fillEqually
        topInterfaceView.spacing = .zero
        topInterfaceView.alignment = .center

        bigStackView.axis = .horizontal
        bigStackView.distribution = .fillEqually
        bigStackView.spacing = .zero
        bigStackView.alignment = .center
        
        leftStackView.axis = .vertical
        leftStackView.distribution = .fillEqually
        leftStackView.spacing = .zero
        leftStackView.alignment = .center
        
        middleStackView.axis = .vertical
        middleStackView.distribution = .equalSpacing
        middleStackView.spacing = .zero
        middleStackView.alignment = .center
        
        rightStackView.axis = .vertical
        rightStackView.distribution = .equalSpacing
        rightStackView.spacing = .zero
        rightStackView.alignment = .center
        
        // create 3 missonaries on the left
        for _ in 0..<3{
            let newButton = createButton(imageName: "Missionary", isMissionary: true)
            leftStackView.addArrangedSubview(newButton)
        }
        // create 3 cannibals on the left
        for _ in 0..<3{
            let newButton = createButton(imageName: "Cannibal-1.png", isMissionary: false)
            leftStackView.addArrangedSubview(newButton)
        }
        
        middleStackView.addArrangedSubview(UIImageView(image: UIImage(named: "river")))
        
        
        mLabel.text = "Missionaries Selected: 0"
        mLabel.adjustsFontSizeToFitWidth = true
        topInterfaceView.addArrangedSubview(mLabel)
        
        cLabel.text = "Cannibals Selected: 0"
        cLabel.adjustsFontSizeToFitWidth = true
        topInterfaceView.addArrangedSubview(cLabel)
        
        blLabel.text = "Boat Location: Left Bank"
        blLabel.adjustsFontSizeToFitWidth = true
        topInterfaceView.addArrangedSubview(blLabel)
        
        bLabel.text = "In Boat: 0 / 2"
        bLabel.adjustsFontSizeToFitWidth = true
        topInterfaceView.addArrangedSubview(bLabel)
        
        crossButton.setTitle("[PRESS TO CROSS]", for: .normal)
        crossButton.setTitleColor(.black, for: .normal)
        crossButton.addTarget(self, action: #selector(crossRiver), for: .touchUpInside)
        topInterfaceView.addArrangedSubview(crossButton)
        
        resetButton.setTitle( "[PRESS TO RESET]", for: .normal)
        resetButton.setTitleColor(.red, for: .normal)
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        bottomInterfaceView.addArrangedSubview(resetButton)
        
        wlLabel.text = ""
        wlLabel.adjustsFontSizeToFitWidth = true
        topInterfaceView.addArrangedSubview(wlLabel)
    }
    
    
    func createButton(imageName: String, isMissionary: Bool) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        
         // tag of this button is 1 for missionary, 0 for cannibal
        button.tag = isMissionary ? 1 : 0
        button.isSelected = false

        button.addTarget(self, action: #selector(characterTapped(_:)), for: .touchUpInside)

        return button
    }

    
    @objc func characterTapped(_ from: UIButton) {
        
        // if there are already 2 characters, stop
        if from.isSelected == false && inBoat > 2 {
            return
        }
        
        // if it is already selected, remove this character from the boat
        if from.isSelected {
            from.isSelected = false
            inBoat -= 1
            if from.tag == 1 {
                missionariesSelected -= 1
                mLabel.text = "Missionaries Selected: \(missionariesSelected)"
            } else {
                cannibalsSelected -= 1
                cLabel.text = "Cannibals Selected: \(cannibalsSelected)"
            }
        }
        // add character to the boat
        else {
            from.isSelected = true
            inBoat += 1
            if from.tag == 1 {
                missionariesSelected += 1
                mLabel.text = "Missionaries Selected: \(missionariesSelected)"
            } else {
                cannibalsSelected += 1
                cLabel.text = "Cannibals Selected: \(cannibalsSelected)"
            }
        }

        bLabel.text = "In Boat: \(inBoat) / 2"
    }

    
    @objc func crossRiver() {
        if inBoat < 1 { return }
        
        let src = boatOnLeft ? leftStackView : rightStackView
        let dest = boatOnLeft ? rightStackView : leftStackView
        
        // gets all arranged subviews of the source stack that are buttons and are selected
        // using compact map creates an array of UIButtons
        let selected = src.arrangedSubviews.compactMap { $0 as? UIButton}.filter { $0.isSelected }
        
        
        // remove character from source and move is to destination
        for button in selected{
            src.removeArrangedSubview(button)
            button.removeFromSuperview()
            dest.addArrangedSubview(button)
            button.isSelected = false
            
        }
        
        // gets the count of all buttons on the stack view with a tag of 1
        mOnLeft = leftStackView.arrangedSubviews.compactMap{$0 as? UIButton}.filter{$0.tag == 1}.count
        
        cOnLeft = leftStackView.arrangedSubviews.compactMap{$0 as? UIButton}.filter{$0.tag == 0}.count
        mOnRight = rightStackView.arrangedSubviews.compactMap{$0 as? UIButton}.filter {$0.tag == 1}.count
        cOnRight = rightStackView.arrangedSubviews.compactMap{$0 as? UIButton}.filter {$0.tag == 0}.count
        
        charactersOnRight = cOnRight + mOnRight
        charactersOnLeft = cOnLeft + mOnLeft
        
        missionariesSelected = 0
        cannibalsSelected = 0
        inBoat = 0
        boatOnLeft = !boatOnLeft
      
        blLabel.text = boatOnLeft ? "Boat Location: Left Bank" : "Boat Location: Right Bank"
        mLabel.text = "Missionaries Selected: 0"
        cLabel.text = "Cannibals Selected: 0"
        bLabel.text = "In Boat: 0 / 2"
        wlLabel.text = ""
        
        if checkLoseCondition(){
            wlLabel.text = "You Lose!"
            return
        }
        
        if checkWinCondition(){
            wlLabel.text = "You Win!"
        }
    }
    
    func checkWinCondition() -> Bool{
        if charactersOnRight == 6{
            return true
        }
        
        return false
    }
    
    func checkLoseCondition() -> Bool {
        if mOnLeft > 0 && cOnLeft > mOnLeft {
            return true
        }
        if mOnRight > 0 && cOnRight > mOnRight {
            return true
        }
        return false
    }

    
    @objc func resetGame(){
        // move all right side characters to the left
        let right = rightStackView.arrangedSubviews.compactMap { $0 as? UIButton }
        for button in right {
            button.isSelected = false
            rightStackView.removeArrangedSubview(button)
            leftStackView.addArrangedSubview(button)
        }
        
        // reset all stats
        boatOnLeft = true
        mOnLeft = 3
        cOnLeft = 3
        mOnRight = 0
        cOnRight = 0
        inBoat = 0
        charactersOnRight = 0
        charactersOnLeft = 6
        missionariesSelected = 0
        cannibalsSelected = 0
        
        mLabel.text = "Missionaries Selected: 0"
        cLabel.text = "Cannibals Selected: 0"
        blLabel.text = "Boat Location: Left Bank"
        mLabel.text = "Missionaries Selected: 0"
        cLabel.text = "Cannibals Selected: 0"
        bLabel.text = "In Boat: 0 / 2"
        wlLabel.text = ""
    }
}

