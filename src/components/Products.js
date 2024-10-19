import React, { useState, useEffect } from 'react';

const Products = () => {
    // Define state for products, name, and price
    const [products, setProducts] = useState([]);
    const [name, setName] = useState('');
    const [price, setPrice] = useState('');

    // Fetch products on component mount
    useEffect(() => {
        fetch('http://localhost:5001/products')
            .then(res => res.json())
            .then(data => setProducts(data));
    }, []);

    // Create a new product
    const createProduct = (e) => {
        e.preventDefault();
        fetch('http://localhost:5001/products', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name, price })
        }).then(() => {
            setProducts([...products, { name, price }]); // Update the products list
            setName(''); // Clear the name input
            setPrice(''); // Clear the price input
        });
    };

    return (
        <div>
            <h2>Products</h2>
            <ul>
                {products.map(product => (
                    <li key={product.id}>{product.name} - ${product.price}</li>
                ))}
            </ul>
            <form onSubmit={createProduct}>
                <input
                    type="text"
                    placeholder="Product Name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    required
                />
                <input
                    type="number"
                    placeholder="Price"
                    value={price}
                    onChange={(e) => setPrice(e.target.value)}
                    required
                />
                <button type="submit">Add Product</button>
            </form>
        </div>
    );
};

export default Products;

