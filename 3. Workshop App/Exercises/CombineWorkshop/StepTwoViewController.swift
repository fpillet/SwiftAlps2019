//
//  StepTwoViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 16/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

/*
 STEP 2:
 Link the nextButton.isEnabled to the three switches isOn values.
 When all switches are set to `true`, the nextButton should be enabled as well.
 In this step, you'll practice combining publishers!
 */

final class StepTwoViewController: UIViewController {

    @IBOutlet private weak var nextButton: UIButton!
    private var switchesSubscriber: AnyCancellable?
    
    private var switchOneValue: Bool = false
    private var switchTwoValue: Bool = false
    private var switchThreeValue: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Your turn!
    }

    @IBAction func switchedOne(_ sender: UISwitch) {
        let switchValue = sender.isOn
        DispatchQueue.global().async {
            self.switchOneValue = switchValue
        }
    }

    @IBAction func switchedTwo(_ sender: UISwitch) {
        let switchValue = sender.isOn
        DispatchQueue.global().async {
            self.switchTwoValue = switchValue
        }
    }

    @IBAction func switchedThree(_ sender: UISwitch) {
        let switchValue = sender.isOn
        DispatchQueue.global().async {
            self.switchThreeValue = switchValue
        }
    }
}

extension StepTwoViewController: WorkshopStepContaining {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        didFinish(.step2)
    }
}
