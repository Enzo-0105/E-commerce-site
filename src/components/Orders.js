import React, { useState, useEffect } from 'react';

const Orders = () => {
    // Define state for orders, userId, productId, and quantity
    const [orders, setOrders] = useState([]);
    const [userId, setUserId] = useState('');
    const [productId, setProductId] = useState('');
    const [quantity, setQuantity] = useState('');

    // Backend URL defined as an environment variable
    const backendUrl = process.env.REACT_APP_ORDERS_BACKEND_URL || 'http://localhost:5002';

    // Fetch orders on component mount
    useEffect(() => {
        fetch(`${backendUrl}/orders`)
            .then(res => res.json())
            .then(data => setOrders(data));
    }, [backendUrl]);

    // Create a new order
    const createOrder = (e) => {
        e.preventDefault();
        fetch(`${backendUrl}/orders`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ user_id: userId, product_id: productId, quantity })
        }).then(() => {
            setOrders([...orders, { user_id: userId, product_id: productId, quantity }]); // Update the orders list
            setUserId(''); // Clear the userId input
            setProductId(''); // Clear the productId input
            setQuantity(''); // Clear the quantity input
        });
    };

    return (
        <div>
            <h2>Orders</h2>
            <ul>
                {orders.map(order => (
                    <li key={order.id}>
                        User ID: {order.user_id}, Product ID: {order.product_id}, Quantity: {order.quantity}
                    </li>
                ))}
            </ul>
            <form onSubmit={createOrder}>
                <input
                    type="text"
                    placeholder="User ID"
                    value={userId}
                    onChange={(e) => setUserId(e.target.value)}
                    required
                />
                <input
                    type="text"
                    placeholder="Product ID"
                    value={productId}
                    onChange={(e) => setProductId(e.target.value)}
                    required
                />
                <input
                    type="number"
                    placeholder="Quantity"
                    value={quantity}
                    onChange={(e) => setQuantity(e.target.value)}
                    required
                />
                <button type="submit">Place Order</button>
            </form>
        </div>
    );
};

export default Orders;

