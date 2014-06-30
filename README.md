NetworkClient
=============

Light weight NSURL and AFNetworking request helper for GET, POST and PUT

Getting Started
===================

Git submodule
-------------------

- Add the NetworkClient code into your project.
- If your project doesn't use ARC, add the -fobjc-arc compiler flag to AppDelegateCoreData.m in your target's Build Phases » Compile    Sources section.
- Add the AFNetworking framework into your project https://github.com/AFNetworking/AFNetworking.

#### Usage example using post ####
```
NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
[postDictionary setValue:[NSString stringWithFormat:@"%0.2f", appDelegate.bestEffortAtLocation.coordinate.latitude] forKey:@"current_lat"];
[postDictionary setValue:[NSString stringWithFormat:@"%0.2f", appDelegate.bestEffortAtLocation.coordinate.longitude] forKey:@"current_lng"];
[[NetworkClient sharedNetworkClient] postAFHTTPRequest:GET_SUGGESTED_URL
                                       atPostParameter:postDictionary
                                               atBlock:^(id responseDictionary, NSError *error) {
                                                    [appDelegate hideHud];
                                                    if (error != nil) {
                                                       ALERT(@"", @"Oop's something went wrong.");
                                                    } else {
                                                       NSLog(@"%@", responseDictionary);
                                                    }
                                               } atKey:@"header_key_if_any"];
```
 

