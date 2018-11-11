import psycopg2

try:
    conn=psycopg2.connect("host='coh-test-db.ccotkfp86qay.us-east-2.rds.amazonaws.com' port='5676' dbname='coh_dvlp' user='Fall2018COH' password='cityofhope'")
except:
    print("I am unable to connect to the database.")

cur = conn.cursor()

try:
	cur.execute( "DROP TABLE johnlee;" )
except:
	print("Can't delete a table if it doesn't exist.")

cur.execute( "CREATE TABLE johnlee (bip_count INTEGER, yeet_frequency INTEGER, is_he_a_ho VARCHAR(255), whose_fault_is_that VARCHAR(255));" )

# cur.execute( "INSERT INTO johnlee (bip_count, yeet_frequency, is_he_a_ho, whose_fault_is_that) VALUES(732, 2, 'Of course', 'John');" )

conn.commit()


