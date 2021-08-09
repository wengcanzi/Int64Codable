//
//  File.swift
//  
//
//  Created by canzi on 2021/8/9.
//

import Foundation
protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

@propertyWrapper
struct CodeDefault<T: DefaultValue> {
    var wrappedValue: T.Value
}

extension CodeDefault: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: CodeDefault<T>.Type, forKey key: Key ) throws -> CodeDefault<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? CodeDefault(wrappedValue: T.defaultValue)
    }
    
    //解析对应类型
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        return try? container.decode(type)
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(type) {
            return value
        } else if let intValue = try? container.decode(Int.self) {
            return String(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            return String(doubleValue)
        }  else if let boolValue = try? container.decode(Bool.self) {
            return String(boolValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Double(stringValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Float(stringValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            if let intValue = Int(stringValue) {
                return intValue
            } else if let doubleValue = Double(stringValue) {
                return Int(doubleValue)
            }
            else {
                return nil
            }
        } else if #available(iOS 11.0, *), let doubleValue = try? container.decode(Double.self) {
            return Int(doubleValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            if let intValue = Int64(stringValue) {
                return intValue
            } else if let doubleValue = Double(stringValue) {
                return Int64(doubleValue)
            }
            else {
                return nil
            }
        } else if #available(iOS 11.0, *), let doubleValue = try? container.decode(Double.self) {
            return Int64(doubleValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        guard try contains(key) && !decodeNil(forKey: key) else { return nil }
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            if let intValue = UInt(stringValue) {
                return intValue
            } else if let doubleValue = Double(stringValue) {
                return UInt(doubleValue)
            }
            else {
                return nil
            }
        } else if #available(iOS 11.0, *), let doubleValue = try? container.decode(Double.self) {
            return UInt(doubleValue)
        }
        return nil
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode<T>(_ type: CodeDefault<T>.Type) throws -> CodeDefault<T> where T: DefaultValue {
        try decodeIfPresent(type) ?? CodeDefault(wrappedValue: T.defaultValue)
    }
    
    mutating func decodeIfPresent(type: Bool.Type) throws -> Bool? {
        return try? decode(type)
    }
    
    mutating func decodeIfPresent(type: Double.Type) throws -> Double? {
        if let value = try? decode(Double.self) {
            return value
        } else if let stringValue = try? decode(String.self) {
            return Double(stringValue)
        }
        return nil
    }
    
    mutating func decodeIfPresent(type: Float.Type) throws -> Float? {
        if let value = try? decode(Float.self) {
            return value
        } else if let stringValue = try? decode(String.self) {
            return Float(stringValue)
        }
        return nil
    }
    
    mutating func decodeIfPresent(type: String.Type) throws -> String? {
        if let value = try? decode(type) {
            return value
        } else if let intValue = try? decode(Int.self) {
            return String(intValue)
        } else if let doubleValue = try? decode(Double.self) {
            return String(doubleValue)
        }  else if let boolValue = try? decode(Bool.self) {
            return String(boolValue)
        }
        return nil
    }
    
    mutating func decodeIfPresent(type: Int.Type) throws -> Int? {
        if let value = try? decode(type) {
            return value
        } else if let stringValue = try? decode(String.self) {
            if let intValue = Int(stringValue) {
                return intValue
            } else if let doubleValue = Double(stringValue) {
                return Int(doubleValue)
            }
            else {
                return nil
            }
        } else if #available(iOS 11.0, *), let doubleValue = try? decode(Double.self) {
            return Int(doubleValue)
        }
        return nil
    }
    
    mutating func decodeIfPresent(type: Int64.Type) throws -> Int64? {
        if let value = try? decode(type) {
            return value
        } else if let stringValue = try? decode(String.self) {
            if let intValue = Int64(stringValue) {
                return intValue
            } else if let doubleValue = Double(stringValue) {
                return Int64(doubleValue)
            }
            else {
                return nil
            }
        } else if #available(iOS 11.0, *), let doubleValue = try? decode(Double.self) {
            return Int64(doubleValue)
        }
        return nil
    }
    
    mutating func decodeIfPresent(type: UInt.Type) throws -> UInt? {
        if let value = try? decode(type) {
            return value
        } else if let stringValue = try? decode(String.self) {
            if let intValue = UInt(stringValue) {
                return intValue
            } else if let doubleValue = Double(stringValue) {
                return UInt(doubleValue)
            }
            else {
                return nil
            }
        } else if #available(iOS 11.0, *), let doubleValue = try? decode(Double.self) {
            return UInt(doubleValue)
        }
        return nil
    }
}

