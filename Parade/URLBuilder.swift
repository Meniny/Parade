//
//  URLBuilder.swift
//  Parade
//

import Foundation

/// URL builder struct.
internal struct URLBuilder {
    /// Builds the query as a string, ready to be added in the URL.
    ///
    /// - Parameter query: Query dictionary.
    /// - Returns: Returns the query as a String.
    internal static func build(query: [String: String]) -> String {
        var finalQuery: String = ""
        for (index, parameter) in query.enumerated() {
            guard let parameterKey = parameter.key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let parameterValue = parameter.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                continue
            }
            finalQuery += index == 0 ? "?" : "&"
            finalQuery += parameterKey + "=" + parameterValue
        }
        return finalQuery
    }
}
