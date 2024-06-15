Data available at:
https://www.pg4e.com/tools/sql/library.csv?PHPSESSID=4b5ea008ebc92a23581d2ac325c1edd9%22

Task:
```
Load this CSV data file into the track_raw table using the \copy command. Then write SQL commands to insert all of the distinct albums into the album table (creating their primary keys) and then set the album_id in the track_raw table.
Then use a INSERT ... SELECT statement to copy the corresponding data from the track_raw table to the track table, effectively dropping the artist and album text fields. 
```
