# AS Font Icon Picker v1.1

**AS Font Icon Picker** is a lightweight, searchable icon picker utility built with [AutoHotkey v2](https://autohotkey.com). It allows developers and designers to browse, search, and copy icons from various icon fonts (such as Segoe MDL2 Assets, Segoe Fluent Icons, Wingdings, etc.) based on external data files.

![Screen Shot](https://www.autohotkey.com/boards/download/file.php?id=28924)

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
3. **Launch:** Run `AS Icon Picker_v1.1_0.ahk`.
4. **Select Font:** Use the dropdown menu at the top to switch between available font data files.
5. **Search & Copy:** Type in the search box to find icons. Use the context menu or double-click to copy to your clipboard.

## Customization
The script uses a flexible structure where `APP` and `Layout` objects manage configurations. You can easily adjust icon sizes, fonts, or colors within the script.

## Contact & Support
- **Author:** Mesut Akcan
- **Email:** makcan@gmail.com
- **Blog:** [akcansoft.blogspot.com](https://akcansoft.blogspot.com) / [mesutakcan.blogspot.com](https://mesutakcan.blogspot.com)
- **GitHub:** [github.com/akcansoft](https://github.com/akcansoft)
- **YouTube:** [youtube.com/mesutakcan](https://youtube.com/mesutakcan)
