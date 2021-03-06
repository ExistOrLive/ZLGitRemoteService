//
//  ZLGithubUserContributionData.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/1/22.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

@objcMembers open class ZLGithubUserContributionData: ZLBaseObject {
    open var contributionsNumber = 0
    open var contributionsDate = ""
    open var contributionsLevel = 0               //  0～4
    open var contributionsWeekday = 0             //  0～6 周日～周六
}
