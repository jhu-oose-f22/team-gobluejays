//
//  CourseDetails.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 10/31/22.
//

import Foundation
struct Meeting: Decodable {
    let DOW: String
    let Dates: String
    let Times: String
    let Location: String
    let Building: String
    let Room: String
}

struct SectionDetail: Decodable {
    let Description: String
    let Meetings: [Meeting]
}

struct RegisteredCourse {
    let semester: String
    let courseNumber: String
    let section: String
    let uuid: String
}

struct CourseDetails: Decodable {
    let TermStartDate: String
    let SchoolName: String
    //"MW 12:00PM - 1:15PM, Th 3:00PM - 3:50PM",
    let Meetings: String
    let OfferingName: String
    let SectionName: String
    let Title: String
    let Credits: String
    let Level: String
    let Areas: String
    let Building: String
    let Term_JSS: String
    let SectionDetails : [SectionDetail]
}

struct courseListCourse {
    let name: String
    let uuid: String
}
