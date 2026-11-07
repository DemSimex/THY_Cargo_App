import pymysql
from pymysql import MySQLError


class DatabaseManager:
    def __init__(self):
        self.config = {
            "host": "localhost",
            "user": "root",
            "password": "Demir.1234",
            "database": "thy_cargo",
            "cursorclass": pymysql.cursors.DictCursor
        }

    def get_connection(self):
        return pymysql.connect(**self.config)

    def get_regions(self):
        conn = self.get_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT region_id, name FROM Region ORDER BY name")
            result = cursor.fetchall()
        conn.close()
        return result

    def get_countries_by_region(self, region_id):
        conn = self.get_connection()
        with conn.cursor() as cursor:
            query = "SELECT country_id, name FROM Country WHERE region_id = %s ORDER BY name"
            cursor.execute(query, (region_id,))
            result = cursor.fetchall()
        conn.close()
        return result

    def get_airports_by_country(self, country_id):
        conn = self.get_connection()
        with conn.cursor() as cursor:
            query = "SELECT * FROM Airport_Rate WHERE country_id = %s ORDER BY city_name"
            cursor.execute(query, (country_id,))
            result = cursor.fetchall()
        conn.close()
        return result

    def get_cargo_categories(self):
        conn = self.get_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Cargo_Category ORDER BY category_id")
            result = cursor.fetchall()
        conn.close()
        return result

    def get_handling_services(self):
        conn = self.get_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Handling_Service ORDER BY service_id")
            result = cursor.fetchall()
        conn.close()
        return result

    def save_quote(self, iata_code, category_id, weight_kg, applied_fix_fee, applied_kg_rate, total_cost, selected_services):
        conn = self.get_connection()
        try:
            with conn.cursor() as cursor:
                quote_sql = """
                    INSERT INTO Shipment_Quote 
                    (iata_code, category_id, weight_kg, applied_fix_fee, applied_kg_rate, total_cost, created_at)
                    VALUES (%s, %s, %s, %s, %s, %s, NOW())
                """
                cursor.execute(quote_sql, (iata_code, category_id, weight_kg, applied_fix_fee, applied_kg_rate, total_cost))
                quote_id = cursor.lastrowid

                if selected_services:
                    service_sql = """
                        INSERT INTO Quote_Services (quote_id, service_id, applied_fee)
                        VALUES (%s, %s, %s)
                    """
                    for service in selected_services:
                        cursor.execute(service_sql, (quote_id, service['service_id'], service['fee']))

            conn.commit()
            return quote_id

        except MySQLError as e:
            conn.rollback()
            raise e
        finally:
            conn.close()


if __name__ == "__main__":
    db = DatabaseManager()
    try:
        regions = db.get_regions()
        categories = db.get_cargo_categories()
        print("MySQL Connection Successful!")
        print(f"Total Regions ({len(regions)}): {[r['name'] for r in regions]}")
        print(f"Total Categories ({len(categories)}): {[c['category_name'] for c in categories]}")
    except Exception as e:
        print(f"Connection Error: {e}")
