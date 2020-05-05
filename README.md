Contributor: Liam McCluskey
Date: 5/5/2020 
**********	Project Files	**********

	/DripNDash
		/DripNDash
			/Model
			- JobRequest.swift: contains the data structure used to store information about a customer's laundry request
			- Customer.swift: contains the data structure used to store information about a customer
			- Dasher.swift: contains the data structure sued to store information about a dasher

			/Controller
			- ContainerController.swift: container for all views in the application
			- SignInController.swift: view controller for the Sign In Page
			- RegisterController.swift: view controller that provides a user the option to register as a dasher or a customer
			- JobHistoryTableController.swift: table controller containing a customer/dasher's past jobs

				/Customer
				- CustomerRegisterController.swift: view controller for registering as a customer
				- CustomerTabBarController.swift: container controller views accessible by tab bar on customer end
				- CustomerHomeController.swift: view controller for the customer homepage
				- CustomerSettingsController.swift: view controller for the customer settings page
				- CustomerJobStatusController.swift: view controller for the customer job status page
				- CustomerJobsTableController.swift: table controller for table showing all in progress requests on customer home page
				- CJSC_StageController.swift: customer view controller for stage views on CustomerJobStatusController
				- CustomerJobHistoryController.swift: view controller for all customer's past requests
				- CustomerJobInfoController.swfit: view controller for specific information about a customer's past request

				/Dasher
				- DasherRegisterController.swift: view controller for registering as a Dasher
				- DasherTabBarController.swift: container controller views accessible by tab bar on Dasher end
				- DasherHomeController.swift: view controller for the Dasher homepage
				- DasherSettingsController.swift: view controller for the Dasher settings page
				- DasherJobStatusController.swift: view controller for the Dasher job status page
				- DasherJobsTableController.swift: table controller for table showing all in progress requests on Dasher home page
				- DasherJobNotificationController.swift: view controller presented showing Dasher a job notification
				- DasherJobHistoryController.swift: view controller for all Dasher's past jobs
				- DasherJobInfoController.swfit: view controller for specific information about a Dasher's past job

			/FirestoreInterface
			- JobRequestFirestore.swift: interface for reads and writes of JobRequest objects and the Firestore Database
			- DasherFirestore.swift: interface for reads and writes of Dasher objects and the Firestore Database
			- CustomerFirestore.swift: interface for reads and writes of Customer objects and the Firestore Database
			

			/Utils
			- Protocols.swift: list of all protocols used mainly to pass information from async methods and events to other view controllers



**********	Running the Project	**********

	!!!!!	REQUIREMENTS TO RUN: Mac computer with Xcode version >= 10.1	!!!!!

	- Runnable File: DripNDash.xcworkspace	{	!!!!!	Do not run DripNDash.xcodeproj file	!!!!!	}

	- Directions To: Test app with two simulators simultaneously (one customer and one dasher) -> This is preferred method as all features are best shown with two instances running

		- Part 1: Run two instances of project
			- Step 1. Open DripNDash.xcworkspace file
			- Step 2. Set simulator to iPhone 7 Plus in the top left corner -> This phone is preferred as simulator seems to run fastest on this phone
			- Step 3. Click the run button in the top left corner
			- Step 4. Wait for project to build successfully. The iPhone 7 Plus simulator should now show the DripNDash login page
			- Step 5. Go back to Xcode and change the simulator to the iPhone 8 Plus simulator -> This phone is also preferred as simulator seems to run fastest on this phone 
			- Step 6. Click the run button on the top left corner.
				- Step 6.1. Xcode will prompt you with a "Stop DripNDash?" message. Click stop and proceed to step 7
			- Step 7. Wait for app to build on iPhone 8 Plus, then click the DripNDash application icon on the iPhone 7 Plus simulator
			- Complete?: You should now see the login page one both iPhone simulators

		- Part 2: Login as a customer and Dasher 
			- Step 1. On one simulator enter the login credentials below to login as a user registered as a customer. Then click the login button
				email: liammail100@gmail.com
				password: password
			- Step 2. On the other simulator enter the login credentials below to login as a user registered as a dasher. Then click the login button
				email: dripndashdeveloper@gmail.com
				password: 
			- Complete?: You should now two different "Home" pages, one on the customer simulator and one on the dasher simulator

		- Part 3: Test all use cases
			- Step 1. Refer to the demo videos at the links provided below on how to implement all use cases
				Link 1: https://www.youtube.com/watch?v=exKRXTIRs7o&t=364s
				Link 2: https://www.youtube.com/watch?v=BF4owo48PG4&t=47s

**********	Installing the Project (Preferred Method)	**********

	!!!!!	REQUIREMENTS TO INSTALL: Mac computer	!!!!!

	Step 1. Open terminal and cd to desired install directory
	Step 2. Enter the command below in the command prompt
		git clone https://github.com/liammccluskey/DripNDash.git
	Complete?: cd into DripNDash and check that the files listed in the top section of this file are in this folder


		
