//
//  Order.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Team Hasso. All rights reserved.
//

import Foundation
import MapKit
import RandomKit

protocol Sampled {
    associatedtype T
    static func generateSamples(amount: Int) -> [T]
    static func generateSample() -> T
}

class ServiceRequest: NSObject {
    let title: String?
    let device: Device
    let creationDate: Date
    let company: Company
    var isScheduled: Bool
    
    var dueDate: Date? = nil
    var events = [Event]()
    
    public init(title: String, device: Device, creationDate: Date = Date(), company: Company, isScheduled: Bool = false) {
        self.title = title
        self.device = device
        self.creationDate = creationDate
        self.company = company
        self.isScheduled = isScheduled
    }
}

extension ServiceRequest: Sampled {
    typealias T = ServiceRequest
    static func generateSamples(amount: Int) -> [ServiceRequest] {
        let titles = [
            "Defect wheel",
            "Scheduled maintenance",
            "HELP plz 😵",
            "Always too loud"
            ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        return (1...amount).map { i in
            return ServiceRequest(title: titles[i % titles.count], device: Device.generateSample(), creationDate: Date.random(using: &Xoroshiro.threadLocal.pointee), company: Company.generateSample())
        }
    }
    
    static func generateSample() -> ServiceRequest {
        return ServiceRequest.generateSamples(amount: 1).first!
    }
}

extension ServiceRequest: MKOverlay {
    public var coordinate: CLLocationCoordinate2D {
        return company.location
    }
    
    public var boundingMapRect: MKMapRect {
        return MKMapRect(origin: MKMapPointForCoordinate(company.location), size: MKMapSize(width: 10.0, height: 10.0))
    }
    
    public var subtitle: String? {
        return company.name
    }
}