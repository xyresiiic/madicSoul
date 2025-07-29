from flask import Flask, request, jsonify, render_template
import psycopg2
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Database configuration
DB_CONFIG = {
    "host": "localhost",
    "database": "cure_connect",
    "user": "postgres",
    "password": "97327",
    "port": "5432"
}

def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)

@app.route("/")
def home():
    return render_template("index.html")  # Main page

@app.route("/chat", methods=["POST"])
def chatbot():
    try:
        data = request.get_json(force=True)
        user_input = data.get("message", "").lower()

        if not user_input:
            return jsonify({"response": "❌ Please enter a valid condition."}), 400

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("SELECT precautions, diet, if_not_working FROM conditions WHERE LOWER(name) = %s", (user_input,))
        condition = cur.fetchone()

        if condition:
            precautions, diet, if_not_working = condition
            response = f"""🔹 Precautions: {precautions}
🔹 Recommended Diet: {diet}
🔹 If Not Working: {if_not_working}"""
        else:
            response = "❌ Sorry, I couldn't find information for that condition."

        cur.close()
        conn.close()

        return jsonify({"response": response})

    except Exception as e:
        print(f"❌ Error in /chat route: {str(e)}")  # Debug log
        return jsonify({"response": f"❌ Server error: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(debug=True)