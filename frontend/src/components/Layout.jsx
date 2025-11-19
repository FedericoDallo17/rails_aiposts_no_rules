import { Outlet, Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useState } from 'react';

export default function Layout() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate(`/search?q=${encodeURIComponent(searchQuery)}`);
    }
  };

  const handleSignOut = () => {
    signOut();
    navigate('/sign-in');
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center space-x-8">
              <Link to="/feed" className="text-2xl font-bold text-blue-600">
                AIPosts
              </Link>
              <form onSubmit={handleSearch} className="hidden md:block">
                <input
                  type="text"
                  placeholder="Search users and posts..."
                  className="w-64 px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </form>
            </div>

            <div className="flex items-center space-x-6">
              <Link to="/feed" className="text-gray-700 hover:text-blue-600">
                Feed
              </Link>
              <Link to="/notifications" className="text-gray-700 hover:text-blue-600">
                Notifications
              </Link>
              <Link to={`/profile/${user?.id}`} className="text-gray-700 hover:text-blue-600">
                Profile
              </Link>
              <Link to="/settings" className="text-gray-700 hover:text-blue-600">
                Settings
              </Link>
              <button
                onClick={handleSignOut}
                className="text-gray-700 hover:text-red-600"
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Outlet />
      </main>
    </div>
  );
}

