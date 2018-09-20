MAS IdentityManagement is the user and group management framework of the iOS Mobile SDK, which is part of CA Mobile API Gateway. It enables developers to securely access users and groups from enterprise identity providers like LDAP, MSAD, and others. Supports creating groups on the fly (called ad hoc groups) for collaborative apps. The underlying protocol is SCIM.

## Features

The MASIdentityManagement framework comes with the following features:

- User retrieval
- Group retrieval and management

## Get Started

- Check out our [documentation][docs] for sample code, video tutorials and more.
- Download [MASIdentityManagement](ttps://github.com/CAAPIM/iOS-MAS-IdentityManagement/archive/master.zip)


## Communication

- *Have general questions or need help?*, use [Stack Overflow][StackOverflow]. (Tag 'massdk')
- *Find a bug?*, open an issue with the steps to reproduce it.
- *Request a feature or have an idea?*, open an issue.

## How You Can Contribute

Contributions are welcome and much appreciated. To learn more, see the [Contribution Guidelines][contributing].

## Installation

MASIdentityManagement supports multiple methods for installing the library in a project.

### Cocoapods (Podfile) Install

To integrate MASIdentityManagement into your Xcode project using CocoaPods, specify it in your **Podfile:**

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

pod 'MASIdentityManagement'
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
#import <MASIdentityManagement/MASIdentityManagement.h>
```

## Usage

### Manage Users

##### Retrieve a user by username
```
//Retrieve a MASUser object that matches the given userName
[MASUser getUserByUserName:sampleUserName completion:^(MASUser *user, NSError *error) {

  //your code here            
}];
```

##### Retrieve a user by id
```
//Retrieve a MASUser object that matches the given objectId
[MASUser getUserByObjectId:sampleUserObjectId completion:^(MASUser *user, NSError *error) {
  
  //your code here            
}];
```

### Manage Groups

Following list of code examples demonstrate basic CRUD operations of ad-hoc group (created on the fly). More advanced operations with using filter request can be found in the next section.

##### Create a group
```
MASGroup *newGroup = [MASGroup group]; 	// create new MASGroup object
newGroup.groupName = @"New group's name"; // set the group name
newGroup.owner = [MASUser currentUser].userName; // set the owner of the group to a current user

[newGroup saveInBackgroundWithCompletion:^(MASGroup *group, NSError *error) {
	
	//your code here
}];
```

##### Retrieve all groups
```
//Retrieve all groups in Identity Management system
[MASGroup getAllGroupsWithCompletion:^(NSArray *groupList, NSError *error, NSUInteger totalResults){
	
	//your code here
}];
```

##### Retrieve a group by group display name
```
//Retrieve an MASGroup object that matches the given displayName
[MASGroup getGroupByGroupName:@"groupName" completion:^(MASGroup *group, NSError *error) {
   
   //your code here
}];
```

##### Retrieve a group by id
```
//Retrieve an MASGroup object that matches the given objectId
[MASGroup getGroupByObjectId:@"objectId" completion:^(MASGroup *group, NSError *error) {

	//your code here
}];
```

##### Add a member to a group
```
MASGroup *thisGroup = retrieve the group object to add a member;
MASUser *thisUser = retrieve the user object to be added;

//Add the member to the group
[thisGroup addMember:thisUser completion:^(MASGroup *group, NSError *error) {
	
	//your code here
}];
```

##### Remove a member from a group
```
MASGroup *thisGroup = retrieve the group object to remove a member;
MASUser *thisUser = retrieve the user object to be removed;

//Remove the member from the group
[thisGroup removeMember:thisUser completion:^(MASGroup *group, NSError *error) {
	
	//your code here
}];
```

##### Delete a group
```
MASGroup *thisGroup = retrieve the group to delete;

//Delete the group
[thisGroup deleteInBackgroundWithCompletion:^(BOOL success, NSError *error) {

	//your code here
}];
```

#### FilteredRequest for Users and Groups

The *MASFilteredRequest* class is a convenience request builder to make the interaction with the Identity Management system extremely easy and void of errors. The Identity Management service is able to use a set of conditions for querying both users and groups consisting of the following conditionals:

- eq - the filter is equal to the attribute value from the Identity Manager.
- ne - the filter is not equal to the attribute value from the Identity Manager.
- co - the filter is contained within the attribute value from the Identity Manager.
- sw - the filter starts with the attribute value from the Identity Manager.
- ew - the filter ends with the attribute value from the Identity Manager.
- pr - the attribute is present in the results from the Identity Manager.
- gt - the filter is greater than the attribute value from the Identity Manager.
- ge - the filter is greater than or equal to the attribute value from the Identity Manager.
- lt - the filter is less than the attribute value from the Identity Manager.
- le - the filter is less than or equal to the attribute value from the Identity Manager.

**Include/Exclude**
To include or exclude attributes, you need to provide a list of attributes in the query, containing either the key <i>attributes=[comma separated attribute list]</i>, or <i>excludedAttributes=[comma separated attribute list]</i>. However, the FilteredRequestBuilder can be used to perform the URL formatting for you. 

To read users from the MAS Identity Management service, use the 
getUsersByFilter api along with the MASFilteredRequest:

##### Create FilteredRequest

```ObjC
//
// Create FilteredRequest
//
MASFilteredRequest *filteredRequest = [MASFilteredRequest filteredRequest];

//      
// Create Filter object. 
// Set the attribute, 'userName' or 'displayName', and the filter. For example, a filter of 'sm'
// would match all users with the userName such as 'Smith', 'Asmil', 'Smeel',
// or all groups with the displayName such as 'Small', 'Smart group'
// etc.
//
MASFilter *filter = [MASFilter filterByAttribute:@"userName" contains:@"sm"];
filteredRequest.filter = filter;

// 
// Set the sortOrder, either descending or ascending.
// sortOrder is an enumeration value with MASFilteredRequestSortOrderDescending or 
// MASFilteredRequestSortOrderAscending.
//
filteredRequest.sortOrder = MASFilteredRequestSortOrderDescending;

//
// Set the pagination for the request.
//
filteredRequest.paginationRange = NSMakeRange(0, 10);

```

##### Use FilteredRequest for retrieving users

By using the FilteredRequest above, users can easily be retrieved that match with the filter request.  There are many other ways of retrieving users without creating a filteredRequest object with several combinations of filter attributes.  For more details on the documentation, please refer to the iOS reference. 

```ObjC

MASFilteredRequest *filteredRequest = filteredRequest object;

//
// Retrieve an array of MASUser objects based on the filterRequest
//
[MASUser getUsersByFilteredRequest:filteredRequest completion:^(NSArray *userList, NSError *error, NSUInteger totalResults) {
	
	if (error)
	{
		// Handle error case here
	}
	else {
		// Handle successful request here
	}
}];
```

##### Use FilteredRequest for retrieving groups

By using the FilteredRequest above, groups can easily be retrieved that match with the filter request.  There are many other ways of retrieving groups without creating a filteredRequest object with several combinations of filter attributes.  For more details on the documentation, please refer to the iOS reference. 

```ObjC

MASFilteredRequest *filteredRequest = filteredRequest object;

//
// Retrieve an array of MASGroup objects based on the filterRequest
//
[MASGroup getGroupsByFilteredRequest:filteredRequest completion:^(NSArray *groupList, NSError *error, NSUInteger totalResults) {
	
	if (error)
	{
		// Handle error case here
	}
	else {
		// Handle successful request here
	}
}];
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
 [download]: https://github.com/CAAPIM/iOS-MAS-IdentityManagement/archive/master.zip
 [contributing]: https://github.com/CAAPIM/iOS-MAS-IdentityManagement/blob/develop/CONTRIBUTING.md
 [license-link]: /LICENSE

