from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Hello from Docker!yohoo 🎉</h1><p>This is a simple Flask app running ia to be build and should be running by surya </p>"

if __name__ == "__main__":
    # For development only: Flask built-in server (works fine for this simple demo).
    # The container maps host port, and host=0.0.0.0 makes it reachable from outside the container.
    app.run(host="0.0.0.0", port=5000, debug=False)
