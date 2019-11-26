//
//  StepOneViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 16/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

/*
 STEP 1:
 Link the nextButton.isEnabled to the buttonSwitch.isOn.
 */

final class StepOneViewController: UIViewController {

    @Published private var buttonSwitchValue: Bool = false
    private var switchSubscriber: AnyCancellable?

    @IBOutlet private weak var buttonSwitch: UISwitch!
    @IBOutlet private weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        switchSubscriber = $buttonSwitchValue
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: nextButton)
    }

    @IBAction func didSwitch(_ sender: UISwitch) {
        let switchValue = sender.isOn
        DispatchQueue.global().async {
            self.buttonSwitchValue = switchValue
        }
    }
}

extension StepOneViewController: WorkshopStepContaining {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        didFinish(.step1)
    }
}
