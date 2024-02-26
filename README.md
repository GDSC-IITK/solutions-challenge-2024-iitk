# Solution-Challenge-2024-Submission
GDSC IITK submission of Solution Challenge

Our project consists of two major components: a mobile application (written in Flutter) and a predictive machine-learning algorithm. This repo is created to compile the two parts: app and ml model.

# Application

	To build the application on your local device follow the steps given below:
	1. Install Flutter https://docs.flutter.dev/get-started/install
	2. Run 'flutter pub get' to install the packages of the repository
	3. Run 'flutter run' after connecting to any emulator, physical device or web browser.
	4. App is ready to use

Please note: We are using couple of api keys which are not present on Github. First one includes: google-services.json file (we are using Firebase as a BaaS) and the API KEY for Gemini.


# ML Model

Instructions on how to run the ML Model:

Navigate to the ML folder in the root directory

	Install the libraries using the following commands inside the ML folder:
	                   pip install requirements.txt

	For Windows Users:
	Type the following commands inside your folder to start the local server:
		$env:FLASK_APP = "model.py"
		flask run

	For Linux and Mac Users:
	Type the following commands inside your folder to start the local server:
		export FLASK_APP=model.py
		flask run
  
  To test the server's functionality, just add a query like the following example: http://localhost:8000/kiosks?lat=22.5080547&lon=88.3533289

