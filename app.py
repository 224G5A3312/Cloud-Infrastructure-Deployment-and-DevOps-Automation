"""
Cloud Infrastructure Deployment and DevOps Automation
------------------------------------------------------
A Flask web application used to demonstrate a complete DevOps workflow:
Docker containerization, GitHub Actions CI, and Terraform-provisioned
AWS EC2 deployment.

Routes:
    /              - Home page
    /about         - About page
    /health        - Health check endpoint (JSON)
    /system-info   - System / runtime information (JSON)

Author: DevOps Portfolio Project
"""

import os
import platform
import socket
from datetime import datetime, timezone

from flask import Flask, render_template, jsonify

app = Flask(__name__)

# ---------------------------------------------------------------------------
# Configuration (read from environment variables, with safe defaults)
# ---------------------------------------------------------------------------
APP_ENV = os.environ.get("ENV", "development")
APP_PORT = int(os.environ.get("PORT", 5000))
APP_VERSION = os.environ.get("APP_VERSION", "1.0.0")


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------
@app.route("/")
def home():
    """Render the home page."""
    return render_template("index.html", env=APP_ENV, version=APP_VERSION)


@app.route("/about")
def about():
    """Render the about page with project/technology details."""
    technologies = [
        "Python (Flask)",
        "Docker",
        "Git & GitHub",
        "GitHub Actions",
        "Terraform",
        "AWS EC2",
        "Linux (Ubuntu)",
    ]
    return render_template("about.html", technologies=technologies)


@app.route("/health")
def health():
    """
    Health check endpoint.

    Used by monitoring tools, load balancers, or manual checks to confirm
    the application is up and responding correctly.
    """
    return jsonify(
        status="healthy",
        service="devops-flask-app",
        environment=APP_ENV,
        version=APP_VERSION,
        timestamp=datetime.now(timezone.utc).isoformat(),
    ), 200


@app.route("/system-info")
def system_info():
    """
    Return basic system and runtime information as JSON.

    Useful for verifying which host/container the app is actually
    running on after deployment.
    """
    info = {
        "hostname": socket.gethostname(),
        "platform": platform.system(),
        "platform_release": platform.release(),
        "python_version": platform.python_version(),
        "environment": APP_ENV,
        "app_version": APP_VERSION,
    }
    return jsonify(info), 200


# ---------------------------------------------------------------------------
# Error Handlers
# ---------------------------------------------------------------------------
@app.errorhandler(404)
def not_found(error):
    """Handle 404 Not Found errors with a JSON response."""
    return jsonify(
        error="Not Found",
        message="The requested resource was not found on this server.",
        status_code=404,
    ), 404


@app.errorhandler(500)
def internal_server_error(error):
    """Handle 500 Internal Server errors with a JSON response."""
    return jsonify(
        error="Internal Server Error",
        message="Something went wrong on the server.",
        status_code=500,
    ), 500


# ---------------------------------------------------------------------------
# Entry Point
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    debug_mode = APP_ENV == "development"
    app.run(host="0.0.0.0", port=APP_PORT, debug=debug_mode)
