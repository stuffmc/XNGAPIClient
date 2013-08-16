#  The official Objective-C XING API Client

XNGAPIClient is the official client to access the XING API. In order to access the API, you only need an account on https://xing.com and an oauth consumer key and secret which can be obtained at https://dev.xing.com. Both is totally free and only takes a minute!

XNGAPIClient is built on top of AFNetworking, so it takes full advantage of blocks. We also included an example project that takes care of storing your oauth token in the keychain to get you started even quicker. At the moment only iOS is supported. Not tested yet on Mac OS X.

## Getting started

### Option 1
If you use [CocoaPods](http://cocoapods.org), you can add the ```XINGAPIClient``` pod to your Podfile. Then run ```pod install```, and the XING API Client will be available in your project.

### Option 2
Clone & Watch our repository by visiting https://github.com/xing/XNGAPIClient

## Optain a consumer key
You can optain a consumer key and consumer secret by visiting https://dev.xing.com/applications and pressing the create app button.

## Set callback URL for OAuth authentication
To authenticate the user via OAuth we switch to Safari. You need to register a callback URL that we can redirect to after
successful login. Using the XING API Client your callback URL scheme will be ```xingapp<YOUR CONSUMER KEY>://```. An example would be ```xingapp4a568854ef676b://```

### Step 1
Register your callback URL on https://dev.xing.com/applications by clicking on the settings icon next to the app you just created and entering the callback URL scheme (as described above) in ```OAuth Dialogue / Callback domain``` field.

### Step 2
Register the same URL scheme in your apps Info.plist:

▾ URL Types (Array)
	▾ Item 0 (Dictionary)
			URL Identifier (String) com.xing.xingapi
			▾ URL Schemes (Array) (1 item)
				Item 0	(String) <YOUR URL SCHEME, like "xingapp4a568854ef676b">

## Configure your App Delegate

1. Import ```#import XNGAPIClient.h``` in your Application Delegate
2. Add following method to your Application Delegate:
``` objective-c
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[XNGAPIClient sharedClient] handleOpenURL:url]) {
        return YES;
    } else {
        //insert your own handling
    }

    return NO;
}
```

## Example Usage

register your consumer key and secret with the shared client:

``` objective-c
XNGAPIClient *client = [XNGAPIClient sharedClient];
client.consumerKey = @"xXxXxXxXxXxXxXxXxXxXxX";
client.consumerSecret = @"xXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxX";
```

login with oauth:

``` objective-c
[client loginOAuthWithSuccess:^{
			 	// handle success
			  }
              failure:^(NSError *error) {
			 	 // handle failure
			  }];
```

make a call to load your own profile:

``` objective-c
[client getUserWithID:@"me"
           userFields:nil
              success:^{
			 	// handle success
			  }
              failure:^(NSError *error) {
			 	 // handle failure
			  }];
```

## Contact

XING AG

- https://github.com/xing
- https://twitter.com/xingdevs
- https://dev.xing.com

## License

XNGAPIClient is available under the MIT license. See the LICENSE file for more info.
