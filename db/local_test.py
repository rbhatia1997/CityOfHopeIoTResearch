import psycopg2

def createDatabase(dbname):
	query = "CREATE DATABASE %s;" % (dbname)
	return query + " "

def deleteDatabase(dbname):
	query = "DROP DATABASE %s;" % (dbname)
	return query + " "

def createTable(tblname):
	query = "CREATE TABLE %s;" % (dbname)
	return query + " "

def deleteTable(tblname):
	query = "DROP TABLE %s;" % (dbname)
	return query + " "

def new_patient(firstName, lastName):
	query = "CREATE TABLE %s_%s ( \
	sessionId INTEGER, \
	timestamp INTEGER, \
	IMU0_X FLOAT(6), IMU0_Y FLOAT(6), IMU0_Z FLOAT(6), \
	IMU1_X FLOAT(6), IMU1_Y FLOAT(6), IMU1_Z FLOAT(6), \
	IMU2_X FLOAT(6), IMU2_Y FLOAT(6), IMU2_Z FLOAT(6), \
	" % (firstName, lastName)
	return query + " "

def readInPatient(id, first, last, dob):
	query = "INSERT INTO patient_list (id, firstname, lastname, dob) \
	VALUES ('%s', '%s', '%s', '%s');" % (id, first, last, dob)
	return query

def deletePatient(id):
	query = "DELETE FROM patient_list WHERE id = '%s';" % (id)
	return query

def main():

	host = "localhost"
	port = "2112"
	dbname = "patient_list"
	user = "darienjoso"
	password = ""

	query = ""

	# host = "coh-test-db.ccotkfp86qay.us-east-2.rds.amazonaws.com"
	# port = "5432"
	# dbname = "coh_dvlp"
	# user = "Fall2018COH"
	# password = "cityofhope"

	info = "host=%s port=%s dbname=%s user=%s password=%s" % (host, port, dbname, user, password)

	try:
		conn = psycopg2.connect(info)
		print("Successful connection to %s at port %s." % (dbname, port))
	except:
		print("Connection failed.")

	conn.autocommit = True

	cur = conn.cursor()


	query
	query += readInPatient("00001", "Pinky", "King", "SEP-28-1997")
	query += readInPatient("00002", "Josephine", "King", "SEP-28-1997")
	# query += deletePatient(1)

	print(query)

	cur.execute(query)

	return 0

if __name__ == "__main__":
	main()

## need to create patient_data database
## need to create patient info table in separate database
## need to create patient processsed data in separate database
## link patient ID as the table name (or find more robust relation)
