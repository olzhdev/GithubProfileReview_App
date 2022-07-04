//
//  ErrorMessage.swift
//  GHFollowers Application
//
//  Created by MAC on 04.07.2022.
//

import Foundation

enum GHError: String, Error {
    case invalidUsername = "This username created invalid request. Please try again."
    case unableToComplete = "Unable to complete request. Please check your internet connection."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "Data received from server was invalid. Please try again."
}
