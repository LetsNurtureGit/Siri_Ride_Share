   //
   //  IntentHandler.swift
   //  SlideToOpen
   //
   //  Created by LetsNurture on 20/09/16.
   //  Copyright © 2016 LetsNurture. All rights reserved.
   //
   
   import Intents
   import  Alamofire
   // As an example, this class is set up to handle Message intents.
   // You will want to replace this or add other intents as appropriate.
   // The intents you wish to handle must be declared in the extension's Info.plist.
   
   // You can test your example integration by saying things to Siri like:
   // "Send a message using <myApp>"
   // "<myApp> John saying hello"
   // "Search for messages in <myApp>"
   // "Get me a ride to the airport using <myApp>"
   // "Book me a ride with Way"
   var mainURL = "http://www.idolbee.com/public/API/"
   class IntentHandler: INExtension,INRequestRideIntentHandling, INGetRideStatusIntentHandling, INListRideOptionsIntentHandling {
    /*!
     @brief handling method
     
     @abstract Execute the task represented by the INRequestRideIntent that's passed in
     @discussion This method is called to actually execute the intent. The app must return a response for this intent.
     
     @param  requestRideIntent The input intent
     @param  completion The response handling block takes a INRequestRideIntentResponse containing the details of the result of having executed the intent
     
     @see  INRequestRideIntentResponse
     */
    public func handle(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
//        let response = INRequestRideIntentResponse(code: .inProgress, userActivity: nil)
//        completion(response)
//        let response1 = INRequestRideIntentResponse(code: .success, userActivity: nil)
//        completion(response1)
//        let mymantra = UserDefaults(suiteName: "group.letsnurture.siriExample")
//        mymantra?.set("done", forKey: "Siri")
//        
//        let url = NSURL(string: "SiriExample://")!
//        // self.extensionContext?.open(url as URL, completionHandler:nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SiriNotify"), object: nil)
        
    }
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        print("intent called")
        return self
    }
    
    
    func confirm(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        
        /*
         Maps uses this method to update the pickup location for the ride.
         
         Confirm with your service whether this pickup -> destination route and payment info is valid.
         
         Use the rideOptionName on the intent to match it to a ride option given in listRideOptions.
         
         In addition, create and update any details on the ride option like fare, or eta for this updated pickup location.
         
         */
        
        URLCache.shared.removeAllCachedResponses()
        let url = String(format:"https://maps.googleapis.com/maps/api/directions/json?origin=23.075877,72.529346&destination=23.080838,72.530422&key=AIzaSyAmy15kj12f3FiDMpEZjvGgHNqj-6155gs&mode=driving")
        Alamofire.request(url, method: .get).responseJSON {(response) -> Void in
            switch response.result{
            case .success:
                if let data = response.result.value as? NSDictionary{
                    if data.value(forKey: "status") as! String == "OK" {
                        if let routes = data.value(forKey: "routes") as? NSArray{
                            if let legs = (routes[0] as AnyObject).value(forKey: "legs") as? NSArray{
                                let timeStr = (legs[0] as AnyObject).value(forKeyPath: "duration.value") as! Int
                                print("google time: \(timeStr)")
                                
                                
                                let minutes = (timeStr % 3600) / 60;
                                let rideOption = INRideOption(name: "Shuttle" , estimatedPickupDate: Date(timeIntervalSinceNow: TimeInterval(Float(minutes * 60))))
                                
                                let rideStatus = INRideStatus()
                                rideStatus.rideOption = rideOption
                                
                                rideStatus.estimatedPickupDate = Date(timeIntervalSinceNow: TimeInterval(Float(minutes * 60)))
                                
                                rideStatus.rideIdentifier = NSUUID().uuidString
                                
                                
                                
                                
                                let response = INRequestRideIntentResponse(code: .success, userActivity: nil)
                                response.rideStatus = rideStatus
                                
                                completion(response)
                                
                            }
                        }
                    }
                }
            case .failure:
                print("failed")
            }
        }
//        var str = ""
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON:NSDictionary = response.result.value as! NSDictionary? {
//                print("JSON: \(JSON.value(forKey: "origin"))")
//                str = JSON.value(forKey: "origin")! as! String
//                let rideOption = INRideOption(name: "Shuttle" , estimatedPickupDate: Date(timeIntervalSinceNow: 5 * 60))
//                
//                let rideStatus = INRideStatus()
//                rideStatus.rideOption = rideOption
//                
//                rideStatus.estimatedPickupDate = Date(timeIntervalSinceNow: 5 * 60)
//                
//                rideStatus.rideIdentifier = NSUUID().uuidString
//                
//                
//                
//                
//                let response = INRequestRideIntentResponse(code: .success, userActivity: nil)
//                response.rideStatus = rideStatus
//                
//                completion(response)
//            }
//        }
    }
    
    func handle(getRideStatus intent: INGetRideStatusIntent, completion: @escaping (INGetRideStatusIntentResponse) -> Void) {
        
        /*
         The intent has no data on it since this method is only asking for a current ride's status.
         
         Query your service to see if there is a current ride in progress. If there is, return the intent response with the .success code and a valid, fully detailed rideStatus object.
         A missing or blank ride option name will cause an error.
         
         Again, the response codes are similar to list ride / request ride and follow the same semantics.
         
         Sending a ride status with a completed phase is valid here, but be sure to set the completionStatus.
         
         If a ride is in the completed state for outstandingPaymentAmount for example, keep sending that status.
         
         Maps will automatically start to ignore a completed state after a set interval.
         
         When the user goes to get another ride, however, you can either allow that, or ask them to complete the previous ride by specifying a response code of .failureRequiringAppLaunchPreviousRideNeedsCompletion.
         */
    }
    
    func startSendingUpdates(forGetRideStatus intent: INGetRideStatusIntent, to observer: INGetRideStatusIntentResponseObserver) {
        
        /*
         It is time for you to start sending updates to the observer. The best thing to do here is to set up a timer to ping your service or some sort of persistent connection to your service.
         
         NOTE: It is completely possible for -startSendingUpdates to be called, and your extension terminated before -stopSendingUpdates is called. In this case, if your extension is restarted, -startSendingUpdates may be called again if you specify in -getRideStatus that there is a current ride.
         
         Store the observer in an ivar and send it the -didUpdate message whenever you have updated information about the current ride.
         
         Maps recommends spacing updates 1-10 seconds apart. Maps will throttle updates as it sees fit.
         */
        
    }
    
    func stopSendingUpdates(forGetRideStatus intent: INGetRideStatusIntent) {
        
        /*
         Stop sending updates and nil out your reference to the observer. Probably stop your timer or close your connection to your service.
         */
        
    }
    
    
    func handle(listRideOptions intent: INListRideOptionsIntent, completion: @escaping (INListRideOptionsIntentResponse) -> Void) {
        
        /*
         We need to do the following here:
         
         1. Get the pickup and dropoff locations from the intent.
         2. Send these locations to your service.
         3. Get back a list of different ride options your service provides between these two points.
         4. Create an intent response with an appropriate response code and data.
         
         */
        
        /*
         Some helpful tips on INListRideOptionsIntentResponseCodes:
         
         - case unspecified
         - Don't use this, it is considered a failure.
         - case ready
         - Don't use this, it is considered a failure.
         - case inProgress
         - Don't use this, it is considered a failure.
         - case success
         - Use this for when there are valid ride options you wish to display.
         - case failure
         - Use this when there is a failure.
         - case failureRequiringAppLaunch
         - Use this when there is a failure which can be recovered from, but only by switching to your parent app.
         - case failureRequiringAppLaunchMustVerifyCredentials
         - Use this when a user is not logged in or signed up for your service in your parent app.
         - case failureRequiringAppLaunchNoServiceInArea
         - Use this when you definitively don't offer service in the general area the user requested ride options in.
         - case failureRequiringAppLaunchServiceTemporarilyUnavailable
         - Use this when you temporarily don't offer service in the general area, for example if there are no vehicles available.
         - case failureRequiringAppLaunchPreviousRideNeedsCompletion
         - Use this when there was a previous ride in your service that the user needs to complete in your parent app. For example if the user still needs to pay for the previous ride. If there is a previous ride that needs completion, but you would still like to allow the user to book another ride, return .success.
         
         For the cases requiringAppLaunch, make sure to include a relevant user activity. This activity will be continued in your parent app if the user chooses to take action on the failure message in Maps. See NSUserActivity documentation here: https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSUserActivity_Class/ .
         
         */
        let response = INListRideOptionsIntentResponse(code: .success, userActivity: nil)
        
        
        /*
         Ride options
         
         Specify a ride option with the INRideOption class. You will have a chance to update the ride option object after a user books a ride, during the ride, and at the end of a ride.
         
         IMPORTANT: When you get a HandleRequestRideIntent below, you will not be handed back the whole ride option. Instead you will be give the following data:
         - pickup location (CLPlacemark)
         - dropoff location (CLPlacemark)
         - ride option name (INSpeakableString)
         - party size (nil if you provided none)
         - payment method (INPaymentMethod)
         
         Therefore, you *must* make the ride option name unique so you can match the listed option with the requested option.
         
         */
        let smallCarOption = INRideOption(name: "Small Car", estimatedPickupDate: Date(timeIntervalSinceNow: 3 * 60)) // You must provide a name and estimated pickup date.
        
//        smallCarOption.priceRange = INPriceRange(firstPrice: NSDecimalNumber(string: "5.60") , secondPrice: NSDecimalNumber(string: "10.78"), currencyCode: "USD") // There are different ways to define a price range and depending on which initializer you use, Maps may change the formatting of the price.
        
        smallCarOption.disclaimerMessage = "This is a free shuttle running for Parking." // A message that is specific to this ride option.
        
        
        /*
         
         Party size options
         
         If you offer different prices for different party sizes for this option, you may use this property to enumerate them. If you do not, leave this nil.
         
         You may have different price ranges for each party size option. If you leave the price range for the party size option nil, it will default to the ride option's price range.
         
         The size description is user visible text.
         */
        smallCarOption.availablePartySizeOptions =  [
            INRidePartySizeOption(partySizeRange: NSRange(location: 0, length: 1), sizeDescription: "One person", priceRange: nil),
//            INRidePartySizeOption(partySizeRange: NSRange(location: 0, length: 2), sizeDescription: "Two people", priceRange: INPriceRange(firstPrice: NSDecimalNumber(string: "6.60") , secondPrice: NSDecimalNumber(string: "11.78"), currencyCode: "USD"))
        ]
//        smallCarOption.availablePartySizeOptionsSelectionPrompt = "Choose a party size"
        
        
        
        /*
         Special pricing
         
         The special pricing string is a user facing string that describes details about the special pricing.
         
         The badge image is shown beside the string as a visual indicator of the special pricing.
         
         Setting either of these properties will result in Maps alerting the user that there is special pricing in effect.
         
         */
//        smallCarOption.specialPricing = "High demand. 50% extra will be added to your fare."
        smallCarOption.specialPricingBadgeImage = INImage(named: "specialPricingBadge")
        
        /*
         Fare line items
         
         These help the user understand the breakdown of the fare for the ride option. You'll have a chance to give updated fare line items after a user books a ride, during the ride, and at the end of the ride.
         */
        
        
        let base = INRideFareLineItem(title: "Base fare", price: NSDecimalNumber(string: "4.76"), currencyCode: "USD" )!
        let airport = INRideFareLineItem(title: "Airport fee", price: NSDecimalNumber(string: "3.00"), currencyCode: "USD" )!
        let discount = INRideFareLineItem(title: "Promo code (3fs8sdx)", price: NSDecimalNumber(string: "-4.00"), currencyCode: "USD" )!
        smallCarOption.fareLineItems = [ base, airport, discount ]
        
        /*
         User activity for booking in application
         
         ONLY set this if this particular ride option is not able to be booked outside of your parent application. For example if the Intents API does not support a particular feature of the ride option.
         
         This will cause Maps to continue the activity in the parent app rather than booking the whole ride inside Maps.
         */
        smallCarOption.userActivityForBookingInApplication = NSUserActivity(activityType: "bookInApp");
        
        response.rideOptions = [ smallCarOption]
        
        /*
         Payment methods
         
         Specify the payment methods that a user has registered with your service. You will be handed back the selected payment method in -handleRequestRideIntent:completion:.
         */
        let paymentMethod = INPaymentMethod(type: .credit, name: "Visa Platinum", identificationHint: "•••• •••• •••• 1234", icon: INImage(named: "creditCardImage"))
        let applePay = INPaymentMethod.applePay()  // If you support Pay and the user has an Pay payment method set in your parent app
        response.paymentMethods = [ paymentMethod, applePay ]
        
        
        /*
         Expiration date
         
         The date at which these ride options expire. When this date is reached, Maps may call -handleListRideOptions:completion: again.
         */
        response.expirationDate = Date(timeIntervalSinceNow: 5 * 60)
    }
   }
   
