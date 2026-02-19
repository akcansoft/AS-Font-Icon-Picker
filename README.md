# AS Font Icon Picker v1.1

**AS Font Icon Picker** is a lightweight, searchable icon picker utility built with [AutoHotkey v2](https://autohotkey.com). It allows developers and designers to browse, search, and copy icons from various icon fonts (such as [Segoe MDL2 Assets](https://learn.microsoft.com/en-us/windows/apps/design/style/segoe-ui-symbol-font), [Segoe Fluent Icons](https://learn.microsoft.com/en-us/windows/apps/design/style/segoe-fluent-icons-font), [Wingdings](https://learn.microsoft.com/en-us/typography/font-list/wingdings), etc.) based on external data files.

![Screen Shot](docs/app_screenshot.png)

## Features
- **Multi-Font Support:** Dynamically loads icon data from CSV files located in the `fonts_data` directory.
- **Searchable Interface:** Quickly filter icons by their Unicode hex code or description.
- **Easy Copying:**
  - **Double-click:** Copy the icon character directly.
  - **Right-click Menu:** Copy the icon character, Unicode hex code, or name/description.
- **Responsive Design:** Resizable window with layout adjustments.
- **About Dialog:** Integrated version and contact information.

## How to Use
1. **Requirements:** Ensure you have [AutoHotkey v2](https://www.autohotkey.com/) installed.
2. **Data Files:** Place your icon data in the `fonts_data` folder. Each font should have its own CSV file (e.g., `Segoe_MDL2_Assets.csv`).
   - Format: `HexCode,Description` (e.g., `E700,Home`)
3. **Launch:** Run `AS Font Icon Picker.ahk`.
4. **Select Font:** Use the dropdown menu at the top to switch between available font data files.
5. **Search & Copy:** Type in the search box to find icons. Use the context menu or double-click to copy to your clipboard.

## About Font Data Files
The application dynamically loads icon data from CSV files. This allows you to easily add support for new icon fonts without modifying the code.

### How to Prepare a Data File
1. **File Name:** Create a new CSV file in the `fonts_data` folder. The filename (excluding the `.csv` extension) must match the exact name of the font installed on your system (e.g., `Segoe MDL2 Assets.csv`).
2. **Format:** Each line in the file should follow the `HexCode,Description` format.
   - **HexCode:** The Unicode hexadecimal value (e.g., `E700`).
   - **Description:** A friendly name or description for the icon (e.g., `Home`).
3. **Encoding:** It is recommended to save the CSV file with **UTF-8** encoding to ensure special characters in descriptions are handled correctly.

### How it Works
- The program lists all `.csv` files found in the `fonts_data` directory.
- When you select a font from the dropdown, the software uses the filename to load the font into the interface.
- It then parses the CSV to display the icons and their descriptions.

### Contribute Your Data
If you have prepared data files for other icon fonts and would like them to be included in this project, you can submit them via:
- **Pull Request**
- **GitHub Issue**
- **Email** (see contact info below)

## Contact & Support
Mesut Akcan
- **Email:** makcan@gmail.com
- **Blog:** [akcansoft.blogspot.com](https://akcansoft.blogspot.com) / [mesutakcan.blogspot.com](https://mesutakcan.blogspot.com)
- **GitHub:** [github.com/akcansoft](https://github.com/akcansoft)
- **YouTube:** [youtube.com/mesutakcan](https://youtube.com/mesutakcan)
