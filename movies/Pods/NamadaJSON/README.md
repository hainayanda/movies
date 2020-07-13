# NamadaJSON
NamadaJSON is a framework to make converting JSON to Swift Object (class or struct) or vice versa easier.

With NamadaJSON, you don't require to make the object to implement mapping function or inherit NSObject.

NamadaJSON is using propertyWrapper and reflection to achive two way mapping.

[![CI Status](https://img.shields.io/travis/nayanda/NamadaJSON.svg?style=flat)](https://travis-ci.org/nayanda/NamadaJSON)
[![Version](https://img.shields.io/cocoapods/v/NamadaJSON.svg?style=flat)](https://cocoapods.org/pods/NamadaJSON)
[![License](https://img.shields.io/cocoapods/l/NamadaJSON.svg?style=flat)](https://cocoapods.org/pods/NamadaJSON)
[![Platform](https://img.shields.io/cocoapods/p/NamadaJSON.svg?style=flat)](https://cocoapods.org/pods/NamadaJSON)

## Requirements

## Installation

NamadaJSON is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NamadaJSON'
```

## Author

Nayanda Haberty, nayanda1@outlook.com

## License

NamadaJSON is available under the MIT license. See the LICENSE file for more info.

## Usage

### Basic Usage

For example, if you need to map User JSON to Swift Object,  you just need to create User class/struct and implement `JSONAble protocol` and then mark all the property you need to map to JSON with `@AutoMapping attributes.`

```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String = ""
    
    @AutoMapping
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    required init() {}
}
```

and then you can parse JSON to User Swift Object or vice versa like this
```swift
let user: User = getUserFromSomewhere()

//to JSON
let jsonObject: [String: Any] = user.toJSON()
let jsonString: String = user.toJSONString()
let prettyJson: String = user.toPrettyPrintedJSON()

//from JSON
let userFromJSON: User? = try? .parse(fromJSONCompatible: jsonObject)
let userFromString: User? = try? .parse(fromJSONString: jsonString)
```

The JSONAble support inheritance, as long as the super are have `@AutoMapping or @ManualMapping attributes` and `implement JSONAble`

```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String = ""
    
    @AutoMapping
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    required init() {}
}

class Admin: User {

    @AutoMapping
    var role: String = ""
}
```

If the property name of JSON is different with property in Swift object, then you can pass the name of the JSON property at the attribute

```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String = ""
    
    // pass the name of the JSON property
    @AutoMapping(key: "user_name")
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    required init() {}
}
```

The supported property data types are: **String, Int (all variant), Double, Float, Bool, any object that implement JSONAble or JSONParseable, and Array of any JSONParseable type** All property can be optional.

```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String?
    
    // pass the name of the JSON property
    @AutoMapping(key: "user_name")
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    @AutoMapping
    var hobbies: [String]?
    
    required init() {}
}
```

### Manual Mapping

If you use unsupported data type for the object property, you have two options: 
- Use the `JSONAbleMapper object`. The provided `JSONAbleMapper` are `StringDateMapper` and `LongDateMapper`. The StringDateMapper is accepting string with your custom pattern and convert it to Date or vice versa. The LongDateMapper is accepting number with `UNIX long date format` and convert it to Date or vice versa. Then you need to passed the mapper to `@ManualMapping property attribute`

```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String?
    
    @AutoMapping(key: "user_name")
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    @AutoMapping
    var hobbies: [String]?
    
    // manual mapping
    @ManualMapping(mapper: StringDateMapper(pattern: "dd-MM-yyyy"))
    var birthDate: Date = .init()
    
    @ManualMapping(mapper: LongDateMapper())
    var registrationDate: Date = .init()
    
    required init() {}
}
```

If your data type is optional, array or both, you can use `forOptional` computed property or `forArray` computed property or even the combination of both, since the property is the extension of the JSONAbleMapper protocol. The order of the property call will affect the result of JSONAbleMapper type.
```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String?
    
    @AutoMapping(key: "user_name")
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    @AutoMapping
    var hobbies: [String]?
    
    // optional
    @ManualMapping(mapper: StringDateMapper(pattern: "dd-MM-yyyy").forOptional)
    var birthDate: Date? = nil
    
    // array
    @ManualMapping(mapper: LongDateMapper().forArray)
    var loginTimes: [Date] = []
    
    // array optional
    @ManualMapping(mapper: LongDateMapper().forArray.forOptional)
    var crashesTimes: [Date]? = nil
    
    // array of optional
    @ManualMapping(mapper: LongDateMapper().forOptional.forArray)
    var someTimes: [Date?] = []
    
    required init() {}
}
```

If you want to implement your own mapper, you can create your own Mapper class/struct that implement `JSONAbleMapper protocol` and use it at `ManualMapping property attribute` like before
```swift
open class MyOwnDateMapper: JSONAbleMapper {
    public typealias MappedObject = Date
    public typealias Parseable = Double
    
    public init() { }
    
    open func from(jsonCompatible: JSONCompatible) throws -> Date {
        guard let long = jsonCompatible.asNumberCompatible?.doubleValue else {
            throw JSONParseableError(description: "Cannot parse date from non number")
        }
        return .init(timeIntervalSince1970: .init(integerLiteral: Int64(long)))
    }
    
    open func toJSONParseable(_ object: Date) -> Double {
        return Double(object.timeIntervalSince1970)
    }
    
    open func toJSONString(_ object: Date) -> String {
        return String(Double(object.timeIntervalSince1970))
    }
}

```

`Parseable associated type` are restricted to any JSONParseable which are **String, Int (all variant), Double, Float, Bool, any object that implement JSONAble or JSONParseable, and Array of any JSONParseable type**.
`MappedObject associated type` is the data type mapped to JSON
`JSONCompatible protocol` is implemented to `native acceptable JSON type in Swift` which are: **NSString, String, NSNumber, Bool, NSDictionary, Dictionary<String, Any>, NSArray, Array<Any> and NSNull** and will be used as the real data type for JSON. Keep in mind, *Optional is not JSONCompatible*, use NSNull instead to represent null.

- The other option is to implement JSONParseable to the data type you want. The only drawback of this method is it will be harder to create multiple parsing method compare to the other method. The advantage of this method is you can use `AutoMapping property attribute` just like the standard method
```swift
extension Date: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        return toJSONString()
    }
    
    public func toJSONString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self).toJSONString()
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let string = compatible as? String, let date = formatter.date(from: myString) else {
            throw JSONParseableError(description: "Cannot parse from any type different than RawValue")
        }
        return date
    }
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        return try parse(fromJSONCompatible: String.parse(fromJSONString: string))
    }
}
```

the function `toJSONCompatible() -> JSONCompatible` and `static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable` will be used as parser from the original data type to native acceptable JSON data type or vice versa.
the function `func toJSONString() -> String` and `static func parse(fromJSONString string: String) throws -> JSONParseable` will be used as parser from string JSON to Swift data type or vice versa.

then you can use the data type like its supported natively

```swift
class User: JSONAble {
    
    @AutoMapping
    var name: String?
    
    @AutoMapping(key: "user_name")
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    @AutoMapping
    var hobbies: [String]?
    
    // date now supported
    @AutoMapping(key: "date_of_birth")
    var dateOfBirth: Date?
    
    required init() {}
}
```

One thing you need to consider, the JSON String is have quotes, so if your mapper is mapping to and from String, don't forget to add quote to the return value, or call `.toJSONString()` function instead.

```swift
open class StringDateMapper: JSONAbleMapper {
    public typealias MappedObject = Date
    public typealias Parseable = String
    
    private lazy var dateFormatter: DateFormatter = .init()
    
    public init(pattern: String) {
        dateFormatter.dateFormat = pattern
    }
    
    open func from(jsonCompatible: JSONCompatible) throws -> Date {
        guard let string = jsonCompatible.asStringCompatible else {
            throw JSONParseableError(description: "Cannot parse date from non string")
        }
        guard let date = dateFormatter.date(from: string) else {
            throw JSONParseableError(description: "Failed to parse string to Date")
        }
        return date
    }
    
    open func toJSONParseable(_ object: Date) -> String {
        return dateFormatter.string(from: object)
    }
    
    // don't forger to add toJSONString(), so it will added quote to the return value
    open func toJSONString(_ object: Date) -> String {
        return dateFormatter.string(from: object).toJSONString()
    }
}
```

The enum with raw representation like String, Int, or any JSONParseable need to implement `JSONParseable protocol` with zero real implementation since the implementations are already implemented in RawRepresentable extension.

```swift
enum UserType: String, JSONParseable {
    case regular
    case premium
    case blacklisted
}
```

and then you can use the date type as JSON property like usual

```swift
class User: JSONAble {
    
    @AutoMapping
    var type: UserType = .regular
    
    @AutoMapping
    var name: String?
    
    @AutoMapping(key: "user_name")
    var userName: String = ""
    
    @AutoMapping
    var age: Int = 0
    
    @AutoMapping
    var hobbies: [String]?
    
    @AutoMapping(key: "date_of_birth")
    var dateOfBirth: Date?
    
    required init() {}
}
```

## Extras

Any object that implement JSONAble protocol can be treated like Dictionary.

``` swift
let user = User()
user["user_name"] = "this is username"

// will print "this is username"
print(user.userName)
let userName: String = user["user_name"] ?? ""
// will print "this is username"
print(userName)
```
