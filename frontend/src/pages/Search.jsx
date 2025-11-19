import { useState, useEffect } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { search as searchApi } from '../services/api';
import PostCard from '../components/PostCard';

export default function Search() {
  const [searchParams] = useSearchParams();
  const query = searchParams.get('q') || '';
  const [activeTab, setActiveTab] = useState('posts');
  const [users, setUsers] = useState([]);
  const [posts, setPosts] = useState([]);
  const [sortBy, setSortBy] = useState('newest');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (query) {
      performSearch();
    }
  }, [query, activeTab, sortBy]);

  const performSearch = async () => {
    setLoading(true);
    try {
      if (activeTab === 'users') {
        const response = await searchApi.users(query);
        setUsers(response.data.users);
      } else {
        const response = await searchApi.posts(query, sortBy);
        setPosts(response.data.posts);
      }
    } catch (error) {
      console.error('Search failed:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Search Results for "{query}"</h1>

      <div className="mb-6">
        <div className="border-b border-gray-200">
          <nav className="flex space-x-8">
            <button
              onClick={() => setActiveTab('posts')}
              className={`py-4 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'posts'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              Posts
            </button>
            <button
              onClick={() => setActiveTab('users')}
              className={`py-4 px-1 border-b-2 font-medium text-sm ${
                activeTab === 'users'
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              Users
            </button>
          </nav>
        </div>
      </div>

      {activeTab === 'posts' && (
        <div className="mb-4">
          <label className="text-sm text-gray-700 mr-2">Sort by:</label>
          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value)}
            className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="newest">Newest</option>
            <option value="oldest">Oldest</option>
            <option value="most_liked">Most Liked</option>
            <option value="most_commented">Most Commented</option>
            <option value="most_recently_commented">Most Recently Commented</option>
            <option value="most_recently_liked">Most Recently Liked</option>
          </select>
        </div>
      )}

      {loading ? (
        <div className="text-center py-8">Searching...</div>
      ) : (
        <div className="space-y-6">
          {activeTab === 'posts' && (
            <>
              {posts.length === 0 ? (
                <div className="text-center py-8 bg-white rounded-lg shadow">
                  <p className="text-gray-600">No posts found</p>
                </div>
              ) : (
                posts.map((post) => (
                  <PostCard key={post.id} post={post} onDelete={() => setPosts(posts.filter(p => p.id !== post.id))} />
                ))
              )}
            </>
          )}

          {activeTab === 'users' && (
            <>
              {users.length === 0 ? (
                <div className="text-center py-8 bg-white rounded-lg shadow">
                  <p className="text-gray-600">No users found</p>
                </div>
              ) : (
                <div className="bg-white rounded-lg shadow divide-y divide-gray-200">
                  {users.map((user) => (
                    <Link
                      key={user.id}
                      to={`/profile/${user.id}`}
                      className="block p-4 hover:bg-gray-50"
                    >
                      <div className="flex items-center space-x-4">
                        {user.profile_picture_url ? (
                          <img
                            src={user.profile_picture_url}
                            alt={user.username}
                            className="w-12 h-12 rounded-full"
                          />
                        ) : (
                          <div className="w-12 h-12 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold">
                            {user.username[0].toUpperCase()}
                          </div>
                        )}
                        <div className="flex-1">
                          <p className="font-bold">{user.full_name}</p>
                          <p className="text-gray-600">@{user.username}</p>
                          {user.bio && (
                            <p className="text-sm text-gray-600 mt-1">{user.bio}</p>
                          )}
                        </div>
                        <div className="text-sm text-gray-600">
                          {user.followers_count} followers
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              )}
            </>
          )}
        </div>
      )}
    </div>
  );
}

