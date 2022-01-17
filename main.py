import psycopg2
from psycopg2._psycopg import DatabaseError

def run2pc():
    acc_connection   = psycopg2.connect("dbname='db_account' user='postgres' host='localhost' password='somePassword' port='5432'")
    fly_connection   = psycopg2.connect("dbname='db_fly_booking' user='postgres' host='localhost' password='somePassword' port='5432'")
    hotel_connection = psycopg2.connect("dbname='db_hotel_booking' user='postgres' host='localhost' password='somePassword' port='5432'")

    acc_cursor   = acc_connection.cursor()
    fly_cursor   = fly_connection.cursor()
    hotel_cursor = hotel_connection.cursor()

    acc_connection.tpc_begin(acc_connection.xid(42, "1", "acc_connection"))
    fly_connection.tpc_begin(acc_connection.xid(42, "1", "fly_connection"))
    hotel_connection.tpc_begin(acc_connection.xid(42, "1", "hotel_connection"))

    try:
        print("Booking hotel...")
        book_hotel = ("Nikolas Cage", "Kupava", "2021-01-17", "2021-01-25", "", "")
        hotel_cursor.execute("INSERT INTO default_schema.hotel_table (client_name, hotel_name, arrival, departure, tr_id, message) "
                        "VALUES (%s, %s, %s, %s, %s,%s)",
                        book_hotel)
    
        print("Booking flight...")
        book_fly = ("Nikolas Cage", "123", "Kyiv", "Lviv", "2021-01-17", "", "")
        fly_cursor.execute("INSERT INTO default_schema.fly_table (client_name, fly_number, f, t, date,  tr_id, message) "
                        "VALUES (%s, %s, %s, %s, %s, %s, %s)",
                        book_fly)
        
        print("Charging money...")
        acc_cursor.execute("UPDATE default_schema.account_table SET amount=amount-50")
        

        acc_connection.tpc_prepare()
        fly_connection.tpc_prepare()
        hotel_connection.tpc_prepare()
    except DatabaseError as e:
        print(e)
        print("Rollback")
        acc_connection.tpc_rollback()
        fly_connection.tpc_rollback()
        hotel_connection.tpc_rollback()
    else:
        print("Commit")
        acc_connection.tpc_commit()
        fly_connection.tpc_commit()
        hotel_connection.tpc_commit()

    acc_cursor.close()
    fly_cursor.close()
    hotel_cursor.close()

    acc_connection.close()
    fly_connection.close()
    hotel_connection.close()
    
run2pc()