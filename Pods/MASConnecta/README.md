MASConnecta is the core messaging framework of the iOS Mobile SDK, which is part of CA Mobile API Gateway. It gives developers the ability to create social collaborative apps where users can message and send data to each other.

## Features

The MASConnecta framework comes with the following features:

- Secure and reliable User to User messaging
- MQTT client with built-in mutual SSL and OAuth support

## Get Started

- Check out our [documentation][docs] for sample code, video tutorials, and more.
- [Download MASConnecta][download] 

## Communication

- *Have general questions or need help?*, use [Stack Overflow][StackOverflow]. (Tag 'massdk')
- *Find a bug?*, open an issue with the steps to reproduce it.
- *Request a feature or have an idea?*, open an issue.

## How You Can Contribute

Contributions are welcome and much appreciated. To learn more, see the [Contribution Guidelines][contributing].

## Installation

MASConnecta supports multiple methods for installing the library in a project.

### Cocoapods (Podfile) Install

To integrate MASConnecta into your Xcode project using CocoaPods, specify it in your **Podfile:**

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

pod 'MASConnecta'
```
Then, run the following command using the command prompt from the folder of your project:

```
$ pod install
```

### Manual Install

For manual install, you add the Mobile SDK to your Xcode project. Note that you must add the MASFoundation library. For complete MAS functionality, install all of the MAS libraries as shown.

1. Open your project in Xcode.
2. Drag the SDK library files, and drop them into your project in the left navigator panel in Xcode. Select the option, `Copy items if needed`.
3. Select `File->Add files to 'project name'` and add the msso_config.json file from your project folder.
4. In Xcode "Build Setting” of your Project Target, add `-ObjC` for `Other Linker Flags`.
5. Import the following Mobile SDK library header file to the classes or to the .pch file if your project has one.

```
#import <MASFoundation/MASFoundation.h>
#import <MASConnecta/MASConnecta.h>
```

## Usage

### Messaging 

After MASConnecta is added to a project, some objects from the MASFoundation library automatically displays messaging methods. This saves you development time and makes the code cleaner. You write just a few lines of code, and the library automatically handles all of the settings for the connection to the server. 

#### Send messages

```objectivec
//Authenticated users have the ability to send messages (Text, Data, Image) to a user

MASUser *myUser = [MASUser currentUser];
MASUser *userB = Some user retrieved from the server

[myUser sendMessage:@"Hello World" toUser:userB completion:^(BOOL success, NSError * _Nullable error) {
    
    NSLog(@"Message Sent : %@\nerror : %@", success ? @"YES":@"NO", error);
}];


```


```objectivec
//Authenticated users can send messages (Text, Data, Image) to a user on a specific topic

MASUser *myUser = [MASUser currentUser];
MASUser *userB = Some user retrieved from the server

//
// Get image from App Bundle
//
NSString* filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
NSData *message = [NSData dataWithContentsOfFile:filePath];

//
// Create MASMessage object
//
MASMessage *messageImage = [[MASMessage alloc] initWithPayloadData:message contentType:@"image/jpeg"];
//
// Send Message to Recipient
//
[myUser sendMessage:messageImage toUser:userB onTopic:@"vacations" completion:^(BOOL success, NSError * _Nullable error) {
    
    NSLog(@"Message Sent : %@\nerror : %@", success ? @"YES":@"NO", error);
}];
        
```

#### Start listening to messages

Start listening to my messages

```objectivec
- (void)viewDidLoad
{
  //
  //Get the current authenticated user
  //
  MASUser *myUser = [MASUser currentUser];
  
    //
    //Listen to Messages sent to my User
    //
    [myUser startListeningToMyMessages:^(BOOL success, NSError *error) {
        
        if (success) {
            
            NSLog(@"Success subscribing to myUser topic!");
        }
        else {
            
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

```

#### Stop listening to messages

Stop listening to my messages

```objectivec
- (void)viewDidLoad
{
  //
  //Get the current authenticated user
  //
  MASUser *myUser = [MASUser currentUser];
  
    //
    //Stop Listening to Messages sent to my User
    //
    [myUser stoplisteningToMyMessages:nil];
}

```

#### Handle incoming messages

Use notifications

```objectivec
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:MASConnectaMessageReceivedNotification
                                               object:nil];
}
```

```objectivec
- (void)didReceiveMessageNotification:(NSNotification *)notification
{    
    //
    //Get the Message Object from the notification
    //
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MASMessage *myMessage = notification.userInfo[MASConnectaMessageKey];

        [weakSelf.profileImage setImage:myMessage.payloadTypeAsImage];
        [weakSelf.messagePayload setText:myMessage.payloadTypeAsString];
    });   
}
```

### Pub/Sub

The MASConnecta library exposes objects that let you: 1) create your own MQTTClient object 2) optionally establish connection with a host using SSL/TLS, 3) set up login and password, and 4) subscribe or publish directly to a topic.

For example:

```objectivec
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    //Creating a new MQTT client
    //
    MASMQTTClient *client = [[MASMQTTClient alloc] initWithClientId:@"myClientID" cleanSession:YES];
    
    
    //
    //Connecting the mqtt client to a host
    //
    [client connectWithHost:@"mas.ca.com" withPort:8883 enableTLS:YES completionHandler:^(MQTTConnectionReturnCode code) {
        
        //Your code here
    }];
    
    
    //
    //Handling messages that arrive
    //
    [client setMessageHandler:^(MASMQTTMessage *message) {
        
        //Your code here
    }];
    
    
    //
    //Subscribing to a topic
    //
    [client subscribeToTopic:@"caTopic" withQos:ExactlyOnce completionHandler:^(NSArray *grantedQos) {
        
        //Your code here
    }];
    
    
    //
    //Publishing a message to a topic
    //
    [client publishString:@"Hello World" toTopic:@"caTopic" withQos:ExactlyOnce retain:YES completionHandler:^(int mid) {
        
        //Your code here
    }];
}
```

## License

Copyright (c) 2016 CA. All rights reserved.

This software may be modified and distributed under the terms
of the MIT license. See the [LICENSE][license-link] file for details.


 [mas.ca.com]: http://mas.ca.com/
 [get-started]: http://mas.ca.com/get-started/
 [docs]: http://mas.ca.com/docs/
 [blog]: http://mas.ca.com/blog/
 [videos]: https://www.ca.com/us/developers/mas/videos.html
 [StackOverflow]: http://stackoverflow.com/questions/tagged/massdk
 [download]: https://github.com/CAAPIM/iOS-MAS-Connecta/archive/master.zip
 [contributing]: https://github.com/CAAPIM/iOS-MAS-Connecta/blob/develop/CONTRIBUTING.md
 [license-link]: /LICENSE
