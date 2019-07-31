# Swift-Data-Controller

A simple swift class to manage URL requests to a custom API, WooCommerce API &amp; Stripe payment processing.

## Getting Started

Import AppDataController.swift into your Xcode project.

Set variables:

    let apiURL
    let user
    let key
    let secret
    let wooURL

Make requests using:
```
AppDataController.shared.request()
AppDataController.shared.checkWCInStock(id:String, variation:String)
AppDataController.shared.removeFromWCStock(id:String, variation:String, stock:Int)
AppDataController.shared.writeWCOrder(orderData:[String:Any])
AppDataController.shared.updateWCOrder(orderNum:String, status:String
AppDataController.shared.submitStripeTokenToBackend(headers:[String:String])
```

### Prerequisites

Import Alamofire:
* [Alamofire](https://github.com/Alamofire/Alamofire) - Networking Framework


## Built With

* [Alamofire](https://github.com/Alamofire/Alamofire) - Networking Framework
* [CocoaPods](https://cocoapods.org) - Dependency Management


## Authors

* **Ernie Lail** - *Initial work* - [MaranathaTech](https://github.com/MaranathaTech)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

