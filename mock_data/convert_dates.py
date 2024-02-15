import re

sql_root = "C:\\Users\\trist\\Documents\\GitHub\\PersonalTrainer\\mock_data\\"

def convert_date_format(date_str):
    parts = date_str.split('/')
    return f"{parts[2]}-{parts[1]}-{parts[0]}"

with open(sql_root+'billing.sql', 'r') as file:
    sql_content = file.read()

pattern = r'\b\d{2}/\d{2}/\d{4}\b'

dates_to_convert = re.findall(pattern, sql_content)

for date in dates_to_convert:
    converted_date = convert_date_format(date)
    sql_content = sql_content.replace(date, converted_date)

with open(sql_root+'temp_conv.sql', 'w') as file:
    file.write(sql_content)

print("Conversion completed.")
