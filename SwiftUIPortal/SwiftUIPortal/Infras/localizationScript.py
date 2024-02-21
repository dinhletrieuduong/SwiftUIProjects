/// To import localizeString.csv
/// 1. Create a new folder named “Scripts”
/// 2. Add file csv to "Scripts" file
/// 3. Go to your Project directory, select the target -> Build Phases -> “+” -> New Run Script Phase
/// 4. Run Script: /usr/bin/python3 "${PROJECT_DIR}/Scripts/localizationScript.py"
/// 5. Go to Project Directory -> Build Settings -> ENABLE_USER_SCRIPT_SANDBOXING = NO
/// 6. Finally, Build the project and check “Localizable” file

import os
import csv
import json

def parseLocalizationCSV(file_name):
    try:
        # Get the directory of the current script
        current_script_path = os.path.abspath(__file__)
        script_directory = os.path.dirname(current_script_path)

        # Construct the full path to the CSV file
        file_path = os.path.join(script_directory, file_name)

        with open(file_path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)

            output = {
                "sourceLanguage": "en",
                "version": "1.0",
                "strings": {}
            }

            for row in reader:
                key = row.pop("DEV_KEY")
                entry = {
                    key: {
                        "localizations": {}
                    }
                }

                for column, value in row.items():
                    if value:
                        entry[key]["localizations"][column] = {
                            "stringUnit": {
                                "state": "translated",
                                "value": value
                            }
                        }

                output["strings"].update(entry)

        saveObjectToJSONFile(output, "Localizable.xcstrings")
    except Exception as e:
        print(f"Error: {str(e)}")

def saveObjectToJSONFile(data, file_name):
    try:
        # Get the absolute path of the current working directory
        current_directory = os.path.abspath(os.getcwd())

        # Define the folder name where you want to save the file
        folder_name = "LocalizationsDemo/Localizations"

        # Construct the full path to the output file
        file_path = os.path.join(current_directory, folder_name, file_name)

        # Ensure the folder exists before saving
        os.makedirs(os.path.dirname(file_path), exist_ok=True)

        with open(file_path, "w") as jsonfile:
            json.dump(data, jsonfile, indent=4)
        
        print(f"Object saved to: {file_path}")
    except Exception as e:
        print(f"Error saving object to file: {str(e)}")

# Apply you localization file name
parseLocalizationCSV('RawLocalizations.csv')
