INSERT INTO mock_data
SELECT * FROM file('data/MOCK_DATA (1).csv', 'CSV')
SETTINGS input_format_csv_skip_first_lines= 1;

INSERT INTO mock_data
SELECT * FROM file('data/MOCK_DATA (2).csv', 'CSV')
SETTINGS input_format_csv_skip_first_lines= 1;

INSERT INTO mock_data
SELECT * FROM file('data/MOCK_DATA (3).csv', 'CSV')
SETTINGS input_format_csv_skip_first_lines= 1;

INSERT INTO mock_data
SELECT * FROM file('data/MOCK_DATA (4).csv', 'CSV')
SETTINGS input_format_csv_skip_first_lines= 1;

INSERT INTO mock_data
SELECT * FROM file('data/MOCK_DATA (5).csv', 'CSV')
SETTINGS input_format_csv_skip_first_lines= 1;