# CarryonEx 

## Update: Sep.9
~~~swift
class Wallet : NSObject {

    var id : String = "123456789"

    var creditAvailable : Float = 6.00
    var creditPending :   Float = 3.00

    var transactions = [Transaction]()

    var checkingAccounts = [CheckingAccount]()
    var creditAccounts = [CreditAccount]()
}
~~~

## Update: Sep.7
- **[ADD]** class Wallet 钱包类:
~~~swift
class Wallet : NSObject {

    var id : String = "123456789"

    var creditAvailable : Float = 0.0
    var creditPending :   Float = 0.0

    var transactions = [Transaction]()

    var checkingAccounts = [CheckingAccount]()

    static var sharedInstance = Wallet()

    private override init() {
    super.init()

    }
}
~~~

- **[ADD]** class User 加入成员:
~~~swift
class User {
    var walletId : String = "123456789" // [ADD]
}
~~~

## Update: Sep.4
- **[ADD]** class User 加入成员:
~~~swift
class User {
    var ordersLogAsSender : [String]? // [ADD] IDs of request I send out
    var ordersLogAsShipper: [String]? // [ADD] IDs of request I take in
}
~~~

- **[ADD]** class Request 加入成员: var status : String
~~~swift
class Request { var status : String! // [ADD] order status: waiting, shipping, finished; }
~~~



## [Server APIs](https://drive.google.com/drive/u/1/folders/0B0THt4NHkGYBTU10Uk93SUhmZDA)
- In gg drive file APIs.xlsx


### - to be continue ...


## Data model class
- dictionary里key的String和变量名一样，如 
~~~swift
func setupBy(dictionary: [String : Any]) {
id = dictionary["id"] as? String
username = dictionary["username"] as? String ?? ""
password = dictionary["password"] as? String

token = dictionary["token"] as? String
... ...
}
~~~

### class User 
~~~swift
var id: String?
var username: String?
var password: String?

var token: Int? // for login server verification

var nickName: String?
var phone:    String?
var phoneCountryCode: String?
var email:    String?
var imageUrl: String?

var idCardA_Url: String?
var idCardB_Url: String?
var passportUrl: String?
var isVerified : Bool = false // [ADD]

var walletId : String = "123456789" // [ADD]

var requestList : [String]? // [ADD]
var tripList : [String]? // tripId

//var ordersLogAsSender : [String]? // [DEL] IDs of request I send out (replaced by requestList)
var ordersLogAsShipper: [String]? // [ADD] IDs of request I take in

var isShipper: Bool?
~~~

### ** ItemCategory ** [ADD：for price info, GET ONLY]
~~~swift
class ItemCategory: NSObject {

    var id : String!

    var nameCN : String?
    var nameEN : String?

    var isEnable: Bool?

    var icon   : UIImage?

    var count : Int = 0 // for category page display and selection
    var prize : Double = 1.0 // parse to Int when upload to server
}
~~~

### class Trip
~~~swift
class Trip : NSObject {

    enum Transportation : String {
        case airplane = "Airplane"
        case car = "Car"
        case bus = "Bus"
    }

    var id: Int!
    var travelerId: String!
    var transportation: Transportation!
    var flightInfo: String?     

    var startAddress: String!
    var endAddress: String!

    var startLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?

    var startTime: Date! 
    var pickupTimeStart: Date! 
    var pickupTimeEnd: Date!
}
~~~

### **class Request**
~~~swift
class Request: NSObject {

    var id: Int!
    var numberOfItem: [String : Int]! // [ItemIdEnum : num]

    var youxiangId: String?
    var status : String! // [ADD] order status: waiting, shipping, finished; 

    var departureAddress = Address() // change to customized class Address
//    var departureCoordinate = CLLocationCoordinate2D() // moved to class Address

    var destinationAddress = Address() // change to customized class Address
//    var destinationCoordinate = CLLocationCoordinate2D() // moved to class Address

    var length: Int!
    var width : Int!
    var height: Int! 
//    var volum: Int! // [DEL] bcz volum = l * w * h
    var weight: Float!

    var sendingTime: [Date]! // current date
    var expectDeliveryTime: Date!
    var realDeliveryTime : Date?

    var cost: Float = 0.0


    var owner : String! // sender id
    var tripId: String?
    var startShippingTimeStamp: Date?
    var endShippingTimeStamp: Date?

}

~~~

### **Address**
~~~swift
class Address : NSObject {

    var id : String!

    var country: Country!
    var state : String!
    var city  : String!

    var street: String!

    var zipcode: String!

// add following members: 

    var recipientName: String!
    var phoneNumber: String!

    var coordinateLongitude: Double = 0.0
    var coordinateLatitude: Double = 0.0

}

enum Country: String {
    case China = "中华人民共和国"
    case UnitedStates = "United States"
}

~~~




## Compatibility
- iOS 9.0+
- Swift 3.0+
- Xcode 8.0+
## Modify pods
-add the ModifyPods file's code to replace the pods the same name file
