//
//  Resource.swift
//  cate
//
//  Created by Winston Li on 25/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class Resource {
    
    let name: String
    let subjectName: String
    let url: String
    let fileType: String?
    
    convenience init(name: String, subjectName: String, url: String) {
        self.init(name: name, subjectName: subjectName, url: url, fileType: nil)
    }
    
    init(name: String, subjectName: String, url: String, fileType: String?) {
        self.name = name
        self.subjectName = subjectName
        self.url = url
        self.fileType = fileType
    }
    
}
