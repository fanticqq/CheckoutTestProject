# CheckoutTestProject

CheckoutTestProject is a small demo app that provides 3D secure payment handling example.

## Features
* Communication with backend via URLSession
* Basic card data validation
* MVVM architecture based on Combine

## Requirements

* Xcode 13+

## Project overview

### Acrhitecture
* `MVVM` is used as an architecture for presentation layer, because it works great with both `UIKit` and `SwiftUI` and provides easy controlled UI-state consistency.

### Presentation layer
* Screens are located in `CheckoutTestProject/Modules` folder.
* `CardInputModule` implements card data input screen which interacts with backend and make redirections to onther screens.
* `CardVerificationModule` handles 3D secure and web-redirection.
* `PaymentResultModule` shows a payment result based on 3D verification.

### Tooling
* Everytning is made without third party solutions

### Things to do/improve
* Add the card number field formatting
* Different handling for back-end errors based on back-end contract 
* Support validation based on card type
* Showing scheme icon when card vendor detected
* Unit Tests for service layer
* Add UI Tests

## License

Copyright 2022 Igor Zarubin.

Licensed under MIT License: https://opensource.org/licenses/MIT
