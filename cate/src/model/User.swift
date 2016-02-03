//
//  File.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class User: EVObject {
    
    var picUrl: String?
    var firstName: String?
    var lastName: String?
    var login: String?
    var cid: String?
    var status: String?
    var department: String?
    var course: String?
    var email: String?
    var personalTutor: String?
    var personalTutorLogin: String?
    var period: Int = 0
    var year: Int = 0
    
    private static let courseDict = [
        "c1": "Computing (Year 1)",
        "c2": "Computing (Year 2)",
        "c3": "Computing (Year 3)",
        "c4": "Computing (Year 4)",
        "i2": "Electronic and Information Engineering (Year 2)",
        "i3": "Electronic and Information Engineering (Year 3)",
        "i4": "Electronic and Information Engineering (Year 4)",
        "j1": "Joint Mathematics and Computer Science (Year 1)",
        "j2": "Joint Mathematics and Computer Science (Year 2)",
        "j3": "Joint Mathematics and Computer Science (Year 3)",
        "j4": "Joint Mathematics and Computer Science (Year 4)",
        "h5": "MRes HiPEDS",
        "r5": "MRes in Advanced Computing",
        "a5": "MSc Advanced Computing",
        "v5": "MSc Computing Science",
        "s5": "Specialism MSc Computing"
    ]
    
    required init() {
        super.init()
    }
    
    init(picUrl: String?,
        firstName: String?,
        lastName: String?,
        login: String?,
        cid: String?,
        status: String?,
        department: String?,
        course: String?,
        email: String?,
        personalTutor: String?,
        personalTutorLogin: String?,
        period: Int,
        year: Int) {
            
        self.picUrl = picUrl
        self.firstName = firstName
        self.lastName = lastName
        self.login = login
        self.cid = cid
        self.status = status
        self.department = department
        self.course = course
        self.email = email
        self.personalTutor = personalTutor
        self.personalTutorLogin = personalTutorLogin
        self.period = period
        self.year = year
            
    }
    
    func getCourseDescription() -> String {
        if let course = self.course {
            if let desc = User.courseDict[course] {
                return desc
            }
            return course
        }
        return ""
    }
    
    func toPersistable() -> UserPersistable {
        return UserPersistable(
            picUrl: picUrl,
            firstName: firstName,
            lastName: lastName,
            login: login,
            cid: cid,
            status: status,
            department: department,
            course: course,
            email: email,
            personalTutor: personalTutor,
            personalTutorLogin: personalTutorLogin,
            period: period,
            year: year
        )
    }
    
}
