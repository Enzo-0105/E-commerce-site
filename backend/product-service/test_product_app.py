# test_app.py
import pytest
from app import app

# Fixture to setup the test client for the Flask app
@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

# Test retrieving all products
def test_get_products(client):
    response = client.get('/products')
    assert response.status_code == 200
    assert isinstance(response.json, list)

# Test retrieving a single product by ID
def test_get_product(client):
    response = client.get('/products/1')
    assert response.status_code == 200
    assert response.json['name'] == 'Laptop'

# Test creating a new product
def test_create_product(client):
    new_product = {"name": "Tablet", "price": 300}
    response = client.post('/products', json=new_product)
    assert response.status_code == 201
    assert response.json['name'] == 'Tablet'

