# NutriScan Application

**NutriScan** is an innovative mobile application that empowers users to make informed, health-conscious food choices. By scanning food product labels for ingredients and nutritional information, NutriScan provides users with instant feedback on the product’s healthiness, allergen risks, and Nutri-Score, helping users make safer and smarter dietary decisions.

## Key Features
- **Ingredients and Nutrition Table Scanner**: Uses Optical Character Recognition (OCR) to scan ingredients and nutrition labels from food products.
- **Nutri-Score Calculation**: Instantly evaluates the healthiness of a product based on its nutritional content and provides a Nutri-Score (ranging from A to E).
- **Allergen Detection**: Alerts users to the presence of potential allergens in scanned products.
- **Ingredient Scraper**: Scrapes and stores detailed ingredient information from the web to provide up-to-date food details.
- **User Profile and Preferences**: Tracks user preferences and provides personalized recommendations based on dietary restrictions and health goals.
  
## Objective
The primary goal of NutriScan is to provide users with real-time, accurate nutritional insights and allergen warnings to facilitate better food choices.

## Scope
NutriScan is designed to serve a wide range of users, from those managing allergies to health-conscious individuals who want to make better dietary choices. The app integrates advanced scanning technology to quickly evaluate food items for allergens and nutritional value, while fostering a supportive community of users sharing recipes and wellness tips.

## Project Modules
1. **User Profile Module**: Stores and tracks user preferences, dietary restrictions, and personal data.
2. **Ingredients and Nutrition Table Scanner**: Scans product labels to extract nutritional and ingredient data.
3. **NutriScan API**: Fetches food data (ingredients, Nutri-Score, additives) from a central database and determines if the product is safe to consume.
4. **Ingredient Scraper**: Scrapes ingredient information from web sources and updates the database.

## Technology Stack
### Frontend:
- **Flutter**: Cross-platform framework used to build the mobile application for Android and iOS.

### Backend:
- **Python (FastAPI)**: Handles API requests for ingredient and nutrition processing.
- **PaddleOCR**: Optical Character Recognition (OCR) used to extract text from scanned food labels.
- **MongoDB Atlas**: A cloud database for storing ingredient and additive information.
- **Beautiful Soup**: Library used for web scraping ingredient data.


## Conclusion
NutriScan bridges the gap between packaged food and digital health by leveraging modern technology like OCR and web scraping to empower users in making healthier choices. The application’s comprehensive approach to nutrition analysis ensures that users are well-informed about their food intake, leading them to a healthier lifestyle.

# NutriScanAPI and It's Demo

Get the NutriScan API [here](https://github.com/shahyaksh/NutriScan-API)
Watch working of the API [here](https://drive.google.com/file/d/1x40lju3RnY4X-gbP00R4zvgIircnKc5G/view?usp=drive_link)

# NutriScan Model Training
Access the NutriScan model [here](https://github.com/shahyaksh/NutriScan-Model)

# Full Demo
Watch the full video of application [here](https://drive.google.com/file/d/1XL3nSaGOhTcGiCDLzhRyKHcaNAXea17H/view?usp=drive_link)

## License
This project is licensed under the MIT License.
