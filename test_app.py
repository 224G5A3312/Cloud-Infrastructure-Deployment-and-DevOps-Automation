"""
test_app.py
------------
Unit tests for the Flask application. Run automatically by the
GitHub Actions CI pipeline on every push.
"""

import pytest
from app import app as flask_app


@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    flask_app.config.update({"TESTING": True})
    with flask_app.test_client() as client:
        yield client


def test_home_page_loads(client):
    """The home page should return a 200 status code."""
    response = client.get("/")
    assert response.status_code == 200


def test_about_page_loads(client):
    """The about page should return a 200 status code."""
    response = client.get("/about")
    assert response.status_code == 200


def test_health_endpoint(client):
    """The /health endpoint should return healthy status as JSON."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "healthy"
    assert data["service"] == "devops-flask-app"


def test_system_info_endpoint(client):
    """The /system-info endpoint should return system details as JSON."""
    response = client.get("/system-info")
    assert response.status_code == 200
    data = response.get_json()
    assert "hostname" in data
    assert "python_version" in data


def test_404_error_handler(client):
    """A request to a non-existent route should return a 404 JSON response."""
    response = client.get("/this-route-does-not-exist")
    assert response.status_code == 404
    data = response.get_json()
    assert data["error"] == "Not Found"
