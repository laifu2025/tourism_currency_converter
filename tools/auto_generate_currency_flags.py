import requests
import os
import time

# --- Configuration ---
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
lib_dir = os.path.join(project_root, "lib", "core", "constants")
assets_dir = os.path.join(project_root, "assets", "flags")
dart_file_path = os.path.join(lib_dir, "currency_country_map.dart")

# --- Step 1: Fetch API data ---
print("Fetching API data...")
try:
    currencies_url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json"
    currencies = requests.get(currencies_url).json()

    country_url = "https://raw.githubusercontent.com/fawazahmed0/exchange-api/main/country.json"
    country_map = requests.get(country_url).json()
    print("API data fetched successfully.")
except requests.exceptions.RequestException as e:
    print(f"Error fetching API data: {e}")
    exit(1)

# --- Step 2: Generate base map from API ---
base_map = {}
for country_code, info in country_map.items():
    currency_code = info.get("currency_code")
    if currency_code:
        # This will overwrite, but we'll fix it with manual overrides
        base_map[currency_code.upper()] = country_code.upper()

# --- Step 3: Define manual additions and overrides ---
# This curated list provides better mappings for common/special cases.
manual_overrides = {
    'EUR': 'EU',  # Euro -> European Union Flag
    'USD': 'US',  # US Dollar -> United States Flag (primary)
    'GBP': 'GB',  # British Pound -> Great Britain Flag
    'XAF': 'CM',  # Central African CFA franc -> Cameroon
    'XOF': 'SN',  # West African CFA franc -> Senegal
    'XPF': 'PF',  # CFP franc -> French Polynesia
    'ANG': 'CW',  # Netherlands Antillean Guilder -> Curaçao
    'XCD': 'AG',  # East Caribbean dollar -> Antigua and Barbuda (representative)
    'GGP': 'GG',  # Guernsey Pound -> Guernsey
    'JEP': 'JE',  # Jersey Pound -> Jersey
    'IMP': 'IM',  # Manx Pound -> Isle of Man
    'TVD': 'TV',  # Tuvaluan dollar -> Tuvalu (uses AUD)
    'CKD': 'CK',  # Cook Islands dollar -> Cook Islands (uses NZD)
    'FOK': 'FO',  # Faroese króna -> Faroe Islands (uses DKK)
    'KID': 'KI',  # Kiribati dollar -> Kiribati (uses AUD)
    'PND': 'PN',  # Pitcairn Islands dollar -> Pitcairn Islands (uses NZD)
    'SHP': 'SH',  # Saint Helena pound -> Saint Helena
}

# --- Step 4: Merge maps ---
# Manual overrides take precedence
final_map = {**base_map, **manual_overrides}

# --- Step 5: Generate Dart file ---
print("Generating Dart map file...")
dart_lines = [
    "// This file is auto-generated and curated. Do not edit manually.",
    "const Map<String, String> currencyToCountryCode = {"
]
country_codes_to_download = set()

# Add all currencies from the fetched list, using our curated map
for code in sorted(currencies.keys()):
    upper_code = code.upper()
    country_code = final_map.get(upper_code)
    if country_code:
        dart_lines.append(f"  '{upper_code}': '{country_code}',")
        country_codes_to_download.add(country_code)

dart_lines.append("};")

os.makedirs(lib_dir, exist_ok=True)
with open(dart_file_path, "w") as f:
    f.write("\n".join(dart_lines))
print(f"Dart map file regenerated: {dart_file_path}")

# --- Step 6: Download all required flags ---
print(f"Starting to download/verify {len(country_codes_to_download)} flags...")
os.makedirs(assets_dir, exist_ok=True)
for code in sorted(country_codes_to_download):
    url = f"https://raw.githubusercontent.com/hampusborgos/country-flags/main/svg/{code.lower()}.svg"
    flag_path = os.path.join(assets_dir, f"{code.lower()}.svg")
    try:
        resp = requests.get(url, timeout=10)
        time.sleep(0.05)
        if resp.status_code == 200:
            with open(flag_path, "wb") as f:
                f.write(resp.content)
        else:
            print(f"  Warning: Could not download {code}.svg (Status: {resp.status_code})")
    except requests.exceptions.RequestException as e:
        print(f"  Error downloading {code}.svg: {e}")

# --- Step 7: Clean up SVG files ---
print("\nCleaning up invalid SVG files (removing percentage dimensions)...")
find_command = f"find {assets_dir} -name '*.svg' -print0"
sed_command = "xargs -0 sed -i '' -E 's/ (x|y|width|height)=\"[^\"]*%\"//g'"
os.system(f"{find_command} | {sed_command}")

print("\nAll tasks completed! The currency map and flags have been enhanced.")
