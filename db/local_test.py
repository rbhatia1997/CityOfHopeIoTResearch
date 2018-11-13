import psycopg2

try:
    conn=psycopg2.connect("host='localhost' port='2112' dbname='darienjoso' user='darienjoso' password=''")
except:
    print("I am unable to connect to the database.")

cur = conn.cursor();

try:
	cur.execute("DROP TABLE yeetDB;")
except:
	print('No table to drop')

cur.execute( "CREATE TABLE yeetDB (IloveDara BOOLEAN);" )
cur.execute( "INSERT INTO yeetDB (IloveDara) VALUES (TRUE);" )

conn.commit()

## need to create patient_data database
## need to create patient info table in separate database
## need to create patient processsed data in separate database
## link patient ID as the table name (or find more robust relation)