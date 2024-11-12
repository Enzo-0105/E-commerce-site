import React, { useState, useEffect } from 'react';

const Users = () => {
    // Define state for users, name, and email
    const [users, setUsers] = useState([]);
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');

    // Backend URL defined as an environment variable
    const backendUrl = process.env.REACT_APP_USERS_BACKEND_URL;

    // Fetch users on component mount
    useEffect(() => {
        fetch(`${backendUrl}/users`)
            .then((res) => res.json())
            .then((data) => setUsers(data));
    }, [backendUrl]);

    // Handle name input change
    const handleNameChange = (e) => {
        setName(e.target.value);
    };

    // Handle email input change
    const handleEmailChange = (e) => {
        setEmail(e.target.value);
    };

    // Create a new user
    const createUser = (e) => {
        e.preventDefault();
        fetch(`${backendUrl}/users`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ name, email }),
        }).then(() => {
            setUsers([...users, { name, email }]); // Update the users list
            setName(''); // Clear the name input
            setEmail(''); // Clear the email input
        });
    };

    return (
        <div>
            <h2>Users</h2>
            <ul>
                {users.map((user) => (
                    <li key={user.id}>
                        {user.name} - {user.email}
                    </li>
                ))}
            </ul>
            <form onSubmit={createUser}>
                <input
                    type="text"
                    placeholder="Name"
                    value={name}
                    onChange={handleNameChange}
                    required
                />
                <input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={handleEmailChange}
                    required
                />
                <button type="submit">Add User</button>
            </form>
        </div>
    );
};

export default Users;

