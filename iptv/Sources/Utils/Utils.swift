import Foundation

enum Result<Value> {
    case value(Value)
    case error(Error)

    init(value: Value) {
        self = .value(value)
    }

    init(error: Error) {
        self = .error(error)
    }
}

enum IPTVError: Error {
    case unknownServerDataFormat
}

enum SeguesIDs: String {
    case channels
    case player
}

enum CellsIDs: String {
    case channel
}
