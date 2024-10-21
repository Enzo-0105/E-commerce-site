from flask import Flask, jsonify, request

app = Flask(__name__)

orders = [
    {"id": 1, "user_id": 1, "product_id": 1, "quantity": 1},
    {"id": 2, "user_id": 2, "product_id": 2, "quantity": 3}
]

@app.route('/orders', methods=['GET'])
def get_orders():
    return jsonify(orders)

@app.route('/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    order = next((o for o in orders if o["id"] == order_id), None)
    return jsonify(order) if order else ('Order not found', 404)

@app.route('/orders', methods=['POST'])
def create_order():
    new_order = request.json
    new_order['id'] = len(orders) + 1
    orders.append(new_order)
    return jsonify(new_order), 201

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5002)

