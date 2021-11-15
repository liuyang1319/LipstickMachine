//
//  IndexChallengeInstructionsView.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class IndexChallengeInstructionsView: BaseView {

    static let share = IndexChallengeInstructionsView.instanceView(type: "IndexChallengeInstructionsView") as! IndexChallengeInstructionsView

    @IBAction private func dismiss() {
        disappear()
    }
}
