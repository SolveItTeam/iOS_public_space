//
//  DomainEntityConvertable.swift
//  
//
//  Created by andrey on 11.04.22.
//

import Foundation

/// Protocol that defines mechanism of convertation from `Model` to `Entity` objects
protocol DomainEntityConvertable {
    associatedtype DomainEntity
    
    func toDomainEntity() -> DomainEntity
}
