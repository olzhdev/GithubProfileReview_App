//
//  ErrorMessage.swift
//  GHFollowers Application
//
//  .
//

import Foundation

/// Custom errors
enum GHError: String, Error {
    case invalidUsername = "This username created invalid request. Please try again."
    case unableToComplete = "Unable to complete request. Please check your internet connection."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "Data received from server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You already favorited this user."
}
