//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by jason9075 on 2015/6/9.
//  Copyright (c) 2015年 Jason Kuan. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}