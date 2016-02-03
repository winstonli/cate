//
//  UserPersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class UserPersistable: NSObject, NSCoding {
    
    private static let PIC_URL_KEY = "User.picUrl"
    private static let FIRST_NAME_KEY = "User.firstName"
    private static let LAST_NAME_KEY = "User.lastName"
    private static let LOGIN_KEY = "User.login"
    private static let CID_KEY = "User.cid"
    private static let STATUS_KEY = "User.status"
    private static let DEPARTMENT_KEY = "User.department"
    private static let COURSE_KEY = "User.course"
    private static let EMAIL_KEY = "User.email"
    private static let PERSONAL_TUTOR_KEY = "User.personalTutor"
    private static let PERSONAL_TUTOR_LOGIN_KEY = "User.personalTutorLogin"
    private static let PERIOD_KEY = "User.period"
    private static let YEAR_KEY = "User.year"
    
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

    required convenience init(coder aDecoder: NSCoder) {
        let picUrl = aDecoder.decodeObjectForKey(UserPersistable.PIC_URL_KEY) as! String?
        let firstName = aDecoder.decodeObjectForKey(UserPersistable.FIRST_NAME_KEY) as! String?
        let lastName = aDecoder.decodeObjectForKey(UserPersistable.LAST_NAME_KEY) as! String?
        let login = aDecoder.decodeObjectForKey(UserPersistable.LOGIN_KEY) as! String?
        let cid = aDecoder.decodeObjectForKey(UserPersistable.CID_KEY) as! String?
        let status = aDecoder.decodeObjectForKey(UserPersistable.STATUS_KEY) as! String?
        let department = aDecoder.decodeObjectForKey(UserPersistable.DEPARTMENT_KEY) as! String?
        let course = aDecoder.decodeObjectForKey(UserPersistable.COURSE_KEY) as! String?
        let email = aDecoder.decodeObjectForKey(UserPersistable.EMAIL_KEY) as! String?
        let personalTutor = aDecoder.decodeObjectForKey(UserPersistable.PERSONAL_TUTOR_KEY) as! String?
        let personalTutorLogin = aDecoder.decodeObjectForKey(UserPersistable.PERSONAL_TUTOR_LOGIN_KEY) as! String?
        let period = aDecoder.decodeIntegerForKey(UserPersistable.PERIOD_KEY)
        let year = aDecoder.decodeIntegerForKey(UserPersistable.YEAR_KEY)
        self.init(
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

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(picUrl, forKey: UserPersistable.PIC_URL_KEY)
        aCoder.encodeObject(firstName, forKey: UserPersistable.FIRST_NAME_KEY)
        aCoder.encodeObject(lastName, forKey: UserPersistable.LAST_NAME_KEY)
        aCoder.encodeObject(login, forKey: UserPersistable.LOGIN_KEY)
        aCoder.encodeObject(cid, forKey: UserPersistable.CID_KEY)
        aCoder.encodeObject(status, forKey: UserPersistable.STATUS_KEY)
        aCoder.encodeObject(department, forKey: UserPersistable.DEPARTMENT_KEY)
        aCoder.encodeObject(course, forKey: UserPersistable.COURSE_KEY)
        aCoder.encodeObject(email, forKey: UserPersistable.EMAIL_KEY)
        aCoder.encodeObject(personalTutor, forKey: UserPersistable.PERSONAL_TUTOR_KEY)
        aCoder.encodeObject(personalTutorLogin, forKey: UserPersistable.PERSONAL_TUTOR_LOGIN_KEY)
        aCoder.encodeInteger(period, forKey: UserPersistable.PERIOD_KEY)
        aCoder.encodeInteger(year, forKey: UserPersistable.YEAR_KEY)
    }

    func toUser() -> User {
        return User(
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
